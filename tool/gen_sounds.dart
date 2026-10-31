// 게임 효과음 WAV 생성기. 실행: dart run tool/gen_sounds.dart
// 출력: assets/sounds/{tap,place,note,wrong,failed,solved}.wav (22.05kHz · mono · 16bit)
// 수치 기준은 이 파일과 test/services/sound_assets_test.dart 가 같이 지킨다.
// 음색은 사람이 듣고 판단한다.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:sudoku/services/sound/sound_cue.dart';

import 'wav.dart';

const rate = 22050;

/// −12dBFS. 모든 클립의 peak 상한.
const maxPeak = 0.251;

int _n(double ms) => (ms * rate / 1000).round();

/// 기음 + 배음 몇 개. 순수 사인보다 덜 "비프"하게 들린다.
double _tone(double t, double f, List<double> partials) {
  var s = 0.0;
  for (var k = 0; k < partials.length; k++) {
    s += partials[k] * math.sin(2 * math.pi * f * (k + 1) * t);
  }
  return s;
}

/// [startMs] 에 시작해 [attackMs] 선형으로 올라가고 τ=[decayMs] 로 지수 감쇠하는 음.
/// [lenMs] 가 있으면 끝에서 [releaseMs] 동안 선형으로 내린다.
void _addNote(
  Float64List out,
  double startMs,
  double f,
  List<double> partials, {
  required double attackMs,
  required double decayMs,
  double? lenMs,
  double releaseMs = 0,
  double gain = 1,
}) {
  final start = _n(startMs);
  final end = lenMs == null
      ? out.length
      : math.min(out.length, start + _n(lenMs));
  for (var i = start; i < end; i++) {
    final tMs = (i - start) * 1000 / rate;
    var env = tMs < attackMs
        ? tMs / attackMs
        : math.exp(-(tMs - attackMs) / decayMs);
    if (lenMs != null && releaseMs > 0) {
      final left = lenMs - tMs;
      if (left < releaseMs) env *= math.max(0, left / releaseMs);
    }
    out[i] += gain * env * _tone(tMs / 1000, f, partials);
  }
}

/// 감쇠 지연 합으로 만든 짧은 잔향.
Float64List _reverb(Float64List dry, List<(double ms, double gain)> taps) {
  final out = Float64List.fromList(dry);
  for (final (ms, g) in taps) {
    final d = _n(ms);
    for (var i = d; i < out.length; i++) {
      out[i] += g * dry[i - d];
    }
  }
  return out;
}

/// 끝 [fadeMs] 동안 sin⁴ 로 내려 마지막 3ms 를 사실상 무음으로 만든다.
void _fadeOut(Float64List s, double fadeMs) {
  final f = _n(fadeMs);
  for (var k = 0; k < f && k < s.length; k++) {
    final g = math.pow(math.sin(math.pi / 2 * k / f), 4);
    s[s.length - 1 - k] *= g;
  }
}

/// 연필 긁는 소리용 띠 통과 잡음. [seed] 가 같으면 결과도 같다 (재생성 결정적).
/// 1극 고역(hpHz)·저역(lpHz) 필터를 차례로 건다.
Float64List _bandNoise(
  int len, {
  required double hpHz,
  required double lpHz,
  int seed = 7,
}) {
  final rnd = math.Random(seed);
  final out = Float64List(len);
  final aH = math.exp(-2 * math.pi * hpHz / rate);
  final aL = math.exp(-2 * math.pi * lpHz / rate);
  var lowOfHp = 0.0, lp = 0.0;
  for (var i = 0; i < len; i++) {
    final x = rnd.nextDouble() * 2 - 1;
    lowOfHp = aH * lowOfHp + (1 - aH) * x;
    final hp = x - lowOfHp;
    lp = aL * lp + (1 - aL) * hp;
    out[i] = lp;
  }
  return out;
}

/// [startMs] 부터 [lenMs] 동안 잡음에 획 모양 봉투(어택 후 완만 감쇠)를 씌워 더한다.
/// [grain] 은 종이 결을 흉내 내는 빠른 진폭 떨림(Hz).
void _addStroke(
  Float64List out,
  Float64List noise,
  double startMs,
  double lenMs, {
  required double attackMs,
  required double decayMs,
  double gain = 1,
  double grain = 170,
}) {
  final start = _n(startMs);
  final end = math.min(out.length, start + _n(lenMs));
  for (var i = start; i < end; i++) {
    final tMs = (i - start) * 1000 / rate;
    var env = tMs < attackMs
        ? tMs / attackMs
        : math.exp(-(tMs - attackMs) / decayMs);
    final left = lenMs - tMs;
    if (left < 8) env *= math.max(0, left / 8);
    env *= 0.75 + 0.25 * math.sin(2 * math.pi * grain * tMs / 1000);
    out[i] += gain * env * noise[i];
  }
}

Float64List _normalize(Float64List s, double peak) {
  var m = 0.0;
  for (final v in s) {
    m = math.max(m, v.abs());
  }
  for (var i = 0; i < s.length; i++) {
    s[i] = s[i] / m * peak;
  }
  return s;
}

Float64List synth(SoundCue cue) {
  switch (cue) {
    case SoundCue.tap:
      // 1.1kHz + 3.3kHz(−12dB), 2ms 선형 어택, τ≈8ms. 나무 블록 같은 짧은 틱.
      final s = Float64List(_n(40));
      _addNote(s, 0, 1100, const [1], attackMs: 2, decayMs: 8);
      _addNote(s, 0, 3300, const [0.25], attackMs: 2, decayMs: 5);
      _fadeOut(s, 10);
      return _normalize(s, 0.16);
    case SoundCue.place:
      // 숫자 기입. 880Hz 가 30ms 안에 660Hz 로 내려오는 "톡"(마림바 느낌) + 2배음.
      // tap 보다 길고 음정이 또렷해 "적혔다"는 느낌을 준다.
      final s = Float64List(_n(100));
      for (var i = 0; i < s.length; i++) {
        final tMs = i * 1000 / rate;
        final env = tMs < 3 ? tMs / 3 : math.exp(-(tMs - 3) / 28);
        // 위상 적분으로 글라이드: f(t) = 660 + 220·e^(−t/12ms)
        final t = tMs / 1000;
        final phase =
            2 * math.pi * (660 * t + 220 * 0.012 * (1 - math.exp(-t / 0.012)));
        s[i] =
            env *
            (math.sin(phase) +
                0.35 * math.sin(2 * phase) +
                0.12 * math.sin(3 * phase));
      }
      _addNote(s, 0, 2640, const [0.18], attackMs: 1, decayMs: 4);
      _fadeOut(s, 25);
      return _normalize(s, 0.19);
    case SoundCue.note:
      // 연필 메모. 1.4–5kHz 띠 잡음에 짧은 획 둘(0–55ms, 60–135ms).
      // 두 번째 획은 조금 약하고 결이 다르게 들리도록 다른 seed 를 쓴다.
      final s = Float64List(_n(140));
      final a = _bandNoise(s.length, hpHz: 1400, lpHz: 5000, seed: 11);
      final b = _bandNoise(s.length, hpHz: 1800, lpHz: 4500, seed: 23);
      _addStroke(s, a, 0, 55, attackMs: 4, decayMs: 30);
      _addStroke(s, b, 60, 75, attackMs: 6, decayMs: 34, gain: 0.8, grain: 140);
      _fadeOut(s, 15);
      return _normalize(s, 0.18);
    case SoundCue.wrong:
      // 330Hz → 262Hz 하강 2음. 부드러운 배음, 음마다 5ms 어택·릴리스.
      final s = Float64List(_n(150));
      const p = [1.0, 0.3, 0.08];
      _addNote(s, 0, 330, p, attackMs: 5, decayMs: 60, lenMs: 70, releaseMs: 5);
      _addNote(
        s,
        72,
        262,
        p,
        attackMs: 5,
        decayMs: 50,
        lenMs: 75,
        releaseMs: 5,
      );
      _fadeOut(s, 20);
      return _normalize(s, 0.20);
    case SoundCue.failed:
      // 하강 2음(294 → 220Hz) + 짧은 잔향.
      final dry = Float64List(_n(400));
      const p = [1.0, 0.35, 0.1];
      _addNote(
        dry,
        0,
        294,
        p,
        attackMs: 6,
        decayMs: 90,
        lenMs: 130,
        releaseMs: 8,
      );
      _addNote(
        dry,
        130,
        220,
        p,
        attackMs: 6,
        decayMs: 110,
        lenMs: 200,
        releaseMs: 20,
      );
      final s = _reverb(dry, const [(37, 0.3), (61, 0.18), (89, 0.1)]);
      _fadeOut(s, 40);
      return _normalize(s, 0.22);
    case SoundCue.solved:
      // C5 · E5 · G5 아르페지오 70ms 간격, 벨 같은 감쇠 + 잔향.
      final dry = Float64List(_n(600));
      const p = [1.0, 0.25, 0.08];
      for (final (k, f) in const [(0, 523.25), (1, 659.25), (2, 783.99)]) {
        _addNote(dry, k * 70.0, f, p, attackMs: 4, decayMs: 140);
      }
      final s = _reverb(dry, const [(41, 0.28), (67, 0.17), (97, 0.1)]);
      _fadeOut(s, 80);
      return _normalize(s, 0.25);
  }
}

/// 테스트와 같은 기준. dart run 은 assert 를 끄므로 직접 던진다.
void check(SoundCue cue, Float64List s) {
  void ensure(bool ok, String what) {
    if (!ok) throw StateError('${cue.name}: $what');
  }

  var peak = 0.0;
  for (final v in s) {
    peak = math.max(peak, v.abs());
  }
  ensure(s.length <= _n(cue.ms.toDouble()), '길이 > ${cue.ms}ms');
  ensure(peak <= maxPeak, 'peak $peak > $maxPeak');
  ensure(s.first.abs() < 0.01, '첫 샘플 ${s.first}');
  for (var i = 0; i < _n(1); i++) {
    ensure(s[i].abs() <= 0.5 * peak, '처음 1ms 가 0.5·peak 초과 (i=$i)');
  }
  for (var i = s.length - _n(3); i < s.length; i++) {
    ensure(s[i].abs() < 0.01, '마지막 3ms 가 0.01 이상 (i=$i)');
  }
}

void main() {
  for (final cue in SoundCue.values) {
    final s = synth(cue);
    check(cue, s);
    final file = File('assets/sounds/${cue.name}.wav');
    writeWav(file, s, rate: rate);
    final back = readWav(file).samples;
    check(cue, back);
    stdout.writeln('${file.path}: ${back.length} samples');
  }
}
