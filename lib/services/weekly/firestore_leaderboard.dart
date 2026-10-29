import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import 'iso_week.dart';
import 'leaderboard_gateway.dart';
import 'weekly_board.dart';

/// Firestore `weekly/{board}/entries/{uid}`. 주간 기능에 처음 들어갈 때 lazy 초기화한다 (W5).
///
/// 생성자에서 `FirebaseFirestore.instance`·`FirebaseAuth.instance` 를 만지지 않는다.
class FirestoreLeaderboard implements LeaderboardGateway {
  FirestoreLeaderboard();

  static const _t = LeaderboardGateway.timeout;

  /// 기록 보존: 주 종료 후 8주 (TTL 필드).
  static const retention = Duration(days: 56);

  Future<bool>? _init;

  Future<bool> _ensureInit() {
    if (!firebaseConfigured) return Future.value(false);
    return _init ??= _initialize().then((ok) {
      if (!ok) _init = null; // 다음에 다시 시도한다.
      return ok;
    });
  }

  Future<bool> _initialize() async {
    try {
      try {
        await Firebase.initializeApp(
          options: currentFirebaseOptions,
        ).timeout(_t);
      } on FirebaseException catch (e) {
        if (e.code != 'duplicate-app') rethrow;
      }
      // 미전송 기록은 우리 큐 하나에만 둔다 (W8).
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: false,
      );
      return true;
    } catch (e) {
      debugPrint('FirestoreLeaderboard 초기화 실패: $e');
      return false;
    }
  }

  CollectionReference<Map<String, dynamic>> _entries(String board) =>
      FirebaseFirestore.instance
          .collection('weekly')
          .doc(board)
          .collection('entries');

  Future<LbResult<T>> _guard<T>(String what, Future<T> Function() body) async {
    try {
      if (!await _ensureInit()) return LbFail<T>();
      return LbOk<T>(await body().timeout(_t));
    } catch (e) {
      debugPrint('FirestoreLeaderboard.$what 실패: $e');
      return LbFail<T>();
    }
  }

  @override
  Future<LbResult<String>> ensureUser() => _guard('ensureUser', () async {
    final auth = FirebaseAuth.instance;
    // 콜드스타트 직후 currentUser 가 null 일 수 있어 복원을 먼저 기다린다 (W7).
    final restored = await auth.authStateChanges().first.timeout(_t);
    final user = restored ?? (await auth.signInAnonymously().timeout(_t)).user;
    if (user == null) throw StateError('익명 로그인 결과 없음');
    return user.uid;
  });

  @override
  Future<LbResult<LeaderEntry?>> mine(String board, String uid) =>
      _guard('mine', () async {
        final d = await _entries(
          board,
        ).doc(uid).get(const GetOptions(source: Source.server));
        return d.exists ? _entry(d.id, d.data()) : null;
      });

  @override
  Future<LbResult<LeaderEntry?>> top(String board) => _guard('top', () async {
    final q = await _entries(
      board,
    ).orderBy('ms').limit(1).get(const GetOptions(source: Source.server));
    if (q.docs.isEmpty) return null;
    final d = q.docs.first;
    return _entry(d.id, d.data());
  });

  @override
  Future<LbResult<void>> write(
    String board,
    String uid, {
    required int ms,
    required String nick,
  }) => _guard('write', () async {
    final wk = WeeklyBoard.parse(board)?.weekKey;
    await _entries(board).doc(uid).set({
      'ms': ms,
      'nick': nick,
      'hintUsed': false,
      'v': 1,
      'updatedAt': FieldValue.serverTimestamp(),
      if (wk != null)
        'expireAt': Timestamp.fromDate(weekEndUtc(wk).add(retention)),
    });
  });

  @override
  Future<LbResult<void>> updateNick(String board, String uid, String nick) =>
      _guard('updateNick', () async {
        await _entries(board).doc(uid).update({
          'nick': nick,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

  static LeaderEntry? _entry(String uid, Map<String, dynamic>? m) {
    final ms = m?['ms'];
    if (ms is! int) return null;
    final nick = m?['nick'];
    return LeaderEntry(uid: uid, ms: ms, nick: nick is String ? nick : '');
  }
}
