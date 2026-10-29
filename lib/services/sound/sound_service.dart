import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'sound_cue.dart';

export 'sound_cue.dart';

/// 효과음 재생기. 세 메서드 모두 예외를 던지지 않는다 (D6).
abstract interface class SoundGateway {
  /// 클립을 미리 올린다. 설정과 무관하게 앱 시작 시 한 번 부른다 (D7).
  Future<void> warmUp();

  /// 앱 복귀 시 오디오 세션을 다시 적용한다. 준비가 실패했으면 다시 시도한다 (D8).
  Future<void> resync();

  /// fire-and-forget. 준비가 덜 됐으면 조용히 버린다.
  void play(SoundCue cue, {double volume = 1});
}

class NoopSoundService implements SoundGateway {
  const NoopSoundService();

  @override
  Future<void> warmUp() async {}

  @override
  Future<void> resync() async {}

  @override
  void play(SoundCue cue, {double volume = 1}) {}
}

/// audioplayers 의 AudioPool 로 짧은 WAV 를 재생한다 (D5).
class AudioPlayersSoundService implements SoundGateway {
  /// iOS 는 무음 스위치를 따르고 다른 앱 음악을 끊지 않는 ambient.
  /// ambient 에 mixWithOthers 를 붙이면 assert 에 걸리므로 options 는 비운다 (D9).
  @visibleForTesting
  static final AudioContext context = AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.ambient,
      options: const {},
    ),
    android: const AudioContextAndroid(
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.game,
      audioFocus: AndroidAudioFocus.none,
    ),
  );

  final _pools = <SoundCue, AudioPool>{};
  Future<void>? _ready;

  @override
  Future<void> warmUp() => _ready ??= _load();

  Future<void> _load() async {
    try {
      for (final cue in SoundCue.values) {
        final n = cue == SoundCue.tap ? 3 : 1;
        _pools[cue] = await AudioPool.create(
          source: AssetSource('sounds/${cue.name}.wav'),
          minPlayers: n,
          maxPlayers: n,
          audioContext: context,
        );
      }
    } catch (e) {
      debugPrint('sound warmUp 실패: $e');
      final made = _pools.values.toList();
      _pools.clear();
      for (final p in made) {
        try {
          await p.dispose();
        } catch (_) {}
      }
    }
  }

  @override
  Future<void> resync() async {
    try {
      await (_ready ?? warmUp());
      if (_pools.length != SoundCue.values.length) {
        _ready = null;
        await warmUp();
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await AudioPlayer.global.setAudioContext(context);
      }
    } catch (e) {
      debugPrint('sound resync 실패: $e');
    }
  }

  @override
  void play(SoundCue cue, {double volume = 1}) {
    final p = _pools[cue];
    if (p == null) return;
    // stop 을 꼭 불러 플레이어를 풀에 돌려준다 (D10).
    unawaited(
      p
          .start(volume: volume)
          .then(
            (stop) => Future<void>.delayed(
              Duration(milliseconds: cue.ms + 100),
              stop,
            ),
            onError: (Object e) => debugPrint('sound: $e'),
          ),
    );
  }
}
