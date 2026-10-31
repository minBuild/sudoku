import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/sound/sound_service.dart';

import '../../tool/wav.dart';

double _peak(List<double> s) => s.fold(0.0, (m, v) => math.max(m, v.abs()));

/// tool/gen_sounds.dart 의 check() 와 같은 기준.
void main() {
  for (final cue in SoundCue.values) {
    test('${cue.name}.wav 형식·길이·peak·시작/끝 가드', () {
      final file = File('assets/sounds/${cue.name}.wav');
      expect(file.existsSync(), isTrue, reason: file.path);

      final w = readWav(file);
      expect(w.bits, 16);
      expect(w.rate, 22050);
      expect(w.channels, 1);
      final s = w.samples;
      expect(s, isNotEmpty);

      final peak = _peak(s);
      final perMs = w.rate / 1000;
      expect(s.length, lessThanOrEqualTo((cue.ms * perMs).round()));
      expect(peak, lessThanOrEqualTo(0.251));
      expect(s.first.abs(), lessThan(0.01));
      for (var i = 0; i < perMs.round(); i++) {
        expect(s[i].abs(), lessThanOrEqualTo(0.5 * peak), reason: '시작 $i');
      }
      for (var i = s.length - (3 * perMs).round(); i < s.length; i++) {
        expect(s[i].abs(), lessThan(0.01), reason: '끝 $i');
      }
    });
  }

  test('peak 순서 tap < note < place < wrong ≤ failed ≤ solved', () {
    double p(SoundCue c) =>
        _peak(readWav(File('assets/sounds/${c.name}.wav')).samples);
    expect(p(SoundCue.tap), lessThan(p(SoundCue.note)));
    expect(p(SoundCue.note), lessThan(p(SoundCue.place)));
    expect(p(SoundCue.place), lessThan(p(SoundCue.wrong)));
    expect(p(SoundCue.wrong), lessThanOrEqualTo(p(SoundCue.failed)));
    expect(p(SoundCue.failed), lessThanOrEqualTo(p(SoundCue.solved)));
  });

  test('pubspec 에 assets/sounds/ 가 있다', () {
    final yaml = File('pubspec.yaml').readAsStringSync();
    expect(yaml, contains('- assets/sounds/'));
  });

  test('iOS 오디오 세션은 ambient + options 없음 (assert 크래시 방지)', () {
    final ios = AudioPlayersSoundService.context.iOS;
    expect(ios.category, AVAudioSessionCategory.ambient);
    expect(ios.options, isEmpty);
    final android = AudioPlayersSoundService.context.android;
    expect(android.usageType, AndroidUsageType.game);
    expect(android.audioFocus, AndroidAudioFocus.none);
  });
}
