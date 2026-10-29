import 'dart:async';

import 'package:flutter/services.dart';

import '../controllers/sudoku_controller.dart';
import '../models/game_status.dart';
import '../services/settings_store.dart';
import '../services/sound/sound_service.dart';

/// 컨트롤러 효과 → 효과음·햅틱. BuildContext 가 필요 없는 피드백만 맡는다 (D1, D11).
class GameFeedback {
  GameFeedback(
    SudokuController c,
    this._sound,
    this._settings, {
    VoidCallback? haptic,
  }) : _haptic = haptic ?? HapticFeedback.mediumImpact {
    _sub = c.effects.listen(_on);
  }

  final SoundGateway _sound;
  final SettingsStore _settings;
  final VoidCallback _haptic;
  late final StreamSubscription<GameEffect> _sub;

  void _on(GameEffect e) {
    final (cue, volume, haptic) = switch (e) {
      GameEffect.selected => (SoundCue.tap, 0.3, false),
      GameEffect.accepted => (SoundCue.tap, 1.0, false),
      GameEffect.wrong || GameEffect.conflict => (SoundCue.wrong, 1.0, true),
      GameEffect.failed => (SoundCue.failed, 1.0, true),
      GameEffect.solved => (SoundCue.solved, 1.0, false),
      GameEffect.firstMistake => (null, 0.0, false),
    };
    if (haptic) _haptic();
    if (cue != null && _settings.soundEnabled) {
      _sound.play(cue, volume: volume);
    }
  }

  void dispose() => _sub.cancel();
}
