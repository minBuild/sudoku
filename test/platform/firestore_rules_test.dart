import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/services/weekly/ranking_policy.dart';
import 'package:sudoku/services/weekly/weekly_board.dart';

/// firebase/firestore.rules 원본에 핵심 조건이 있는지, Dart 미러와 맞는지.
void main() {
  final rules = File('firebase/firestore.rules').readAsStringSync();

  test('본인 기록만, 더 빠를 때만, 삭제 금지', () {
    expect(rules, contains('match /weekly/{board}/entries/{uid}'));
    expect(rules, contains('allow read: if request.auth != null;'));
    expect(rules, contains('request.auth.uid == uid'));
    expect(rules, contains('request.resource.data.ms < resource.data.ms'));
    expect(rules, contains("affectedKeys().hasOnly(['nick', 'updatedAt'])"));
    expect(rules, contains('allow delete: if false;'));
    expect(rules, contains('d.hintUsed == false'));
    expect(rules, contains('d.updatedAt == request.time'));
  });

  test('ms·닉네임 상한이 RankingPolicy 와 같다', () {
    expect(rules, contains('d.ms >= ${RankingPolicy.minMs}'));
    expect(rules, contains('d.ms <= ${RankingPolicy.maxMs}'));
    expect(rules, contains('d.nick.size() <= ${RankingPolicy.maxServerNick}'));
  });

  test('보드 정규식이 WeeklyBoard.idRe 와 같은 샘플을 허용한다', () {
    final m = RegExp(r"board\.matches\('([^']+)'\)").firstMatch(rules);
    expect(m, isNotNull);
    final ruleRe = RegExp(m!.group(1)!);
    final samples = [
      for (final d in Difficulty.values) WeeklyBoard('2026-W44', d).id,
      '2027-W01_hell_g12',
      '2026-W44_nightmare_g1',
      '2026-W4_hard_g1',
      '2026-W44_hard',
      '2026-W44_hard_g1/x',
      'x2026-W44_hard_g1',
    ];
    for (final s in samples) {
      expect(ruleRe.hasMatch(s), WeeklyBoard.idRe.hasMatch(s), reason: s);
    }
  });
}
