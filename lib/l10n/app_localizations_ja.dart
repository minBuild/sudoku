// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '数独';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => '整った没頭、脳のための毎日の休息';

  @override
  String get newGame => '新しいゲーム';

  @override
  String get records => '記録';

  @override
  String get settings => '設定';

  @override
  String get continueTitle => 'プレイ中のゲーム';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '完了率 $progressString · 経過時間 $time';
  }

  @override
  String get overwriteTitle => '新しいゲームを始めますか？';

  @override
  String get overwriteBody => 'プレイ中のゲームは失われます。';

  @override
  String get saveIncompatible => '以前のバージョンで保存されたゲームは再開できないため削除しました。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get removeAds => '広告を削除';

  @override
  String removeAdsWithPrice(String price) {
    return '広告を削除 $price';
  }

  @override
  String get removeAdsDesc => '一度の購入でずっと広告なし';

  @override
  String get removeAdsLongDesc => '一度の購入ですべての広告を永久に削除し、パズルに集中しましょう。';

  @override
  String get adsRemoved => '広告削除済み';

  @override
  String get purchasePending => '処理中';

  @override
  String get storeUnavailable => 'ストアに接続できません';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get restoreRequested => '購入履歴を確認しています';

  @override
  String get purchaseFailed => '決済を完了できませんでした。しばらくしてからもう一度お試しください';

  @override
  String get restoreFailed => '購入の復元に失敗しました。しばらくしてからもう一度お試しください';

  @override
  String get restoreNone => '復元できる購入はありません';

  @override
  String get resultRemoveAdsLine => '広告なしで遊びませんか？';

  @override
  String get chooseDifficulty => '難易度を選択';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '$max回ミスでゲームオーバー · 元に戻してもミス回数は減りません',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'まもなく開始します';

  @override
  String get preparingSub => '新しいパズルを作成しています…';

  @override
  String get puzzleFailed => 'パズルを作成できませんでした。もう一度お試しください';

  @override
  String get back => '戻る';

  @override
  String get more => 'その他';

  @override
  String get restartSame => '同じパズルを再挑戦';

  @override
  String get restartConfirmTitle => '同じパズルを最初からやり直しますか？';

  @override
  String get restartConfirmBody => '入力した数字、時間、ミス回数がすべてリセットされます。';

  @override
  String get instantCheck => '即時チェック';

  @override
  String mistakes(int count, int max) {
    return 'ミス $count/$max';
  }

  @override
  String get undo => '元に戻す';

  @override
  String get erase => '消す';

  @override
  String get memo => 'メモ';

  @override
  String get memoOn => 'メモ オン';

  @override
  String get mistakeKept => '元に戻してもミス回数は減りません';

  @override
  String cellEmpty(int row, int column) {
    return '$row行 $column列、空き';
  }

  @override
  String cellValue(int row, int column, int value) {
    return '$row行 $column列、$value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number、残り $count';
  }

  @override
  String get cleared => 'クリア！';

  @override
  String get gameOver => 'ゲームオーバー';

  @override
  String clearedSub(String difficulty) {
    return '$difficultyをクリアしました';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'ミスが$max回に達しました',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 新記録';

  @override
  String get time => '時間';

  @override
  String get mistakeCount => 'ミス';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count回',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => '難易度';

  @override
  String get home => 'ホームへ';

  @override
  String get all => 'すべて';

  @override
  String get bestRecords => 'ベスト記録';

  @override
  String get bestRecordsSub => '難易度別の最短クリア時間';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最近の記録 ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'まだ記録がありません';

  @override
  String get noRecordsSub => 'パズルをクリアするとここに記録されます';

  @override
  String get clearTime => 'クリア時間';

  @override
  String get checkOff => 'チェックなし';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ミス $count回',
    );
    return '$_temp0';
  }

  @override
  String recordDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get clearAll => 'すべて削除';

  @override
  String get clearAllTitle => '記録をすべて削除しますか？';

  @override
  String get clearAllBody => '削除した記録は元に戻せません。';

  @override
  String get delete => '削除';

  @override
  String get instantCheckDefault => '即時チェックを標準にする';

  @override
  String get instantCheckDesc => '誤った数字を入力するとすぐに表示します';

  @override
  String get soundEffects => '効果音';

  @override
  String get soundEffectsDesc => '入力・ミス・クリアの音';

  @override
  String get privacyOptions => 'プライバシー オプション';

  @override
  String get privacyOptionsDesc => '広告の同意設定を確認または変更します';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get openLinkFailed => 'リンクを開けませんでした';

  @override
  String get appVersion => 'アプリのバージョン';

  @override
  String get footer => '数独 (Sudoku JANG)';

  @override
  String get difficultyEasy => 'かんたん';

  @override
  String get difficultyNormal => 'ふつう';

  @override
  String get difficultyHard => 'むずかしい';

  @override
  String get difficultyExpert => 'エキスパート';

  @override
  String get difficultyHell => '地獄';

  @override
  String get hint => 'ヒント';

  @override
  String get hintUse => 'ヒントを使う';

  @override
  String get hintRankingWarn => 'ヒントを使うと今週のランキング対象外になります';

  @override
  String get rewardHintTitle => '広告を見てヒントをもらう';

  @override
  String get rewardHintBody => '短い広告を最後まで見るとヒントが1つもらえます。無料ヒントは明日また3つに戻ります。';

  @override
  String get rewardContinueBody => '短い広告を最後まで見るとミスが0に戻り、続きから遊べます。';

  @override
  String get watchAd => '広告を見る';

  @override
  String get adLoading => '広告を読み込み中…';

  @override
  String get adUnavailable => '現在広告を読み込めません';

  @override
  String get adNotCompleted => '報酬を受け取るには広告を最後まで見てください';

  @override
  String get continueAfterFail => '続ける';

  @override
  String get continueWithAd => '広告を見て続ける';

  @override
  String get weeklyTitle => '週間チャレンジ';

  @override
  String weeklyWeekLabel(int week) {
    return '第$week週';
  }

  @override
  String weeklyEndsAt(String date) {
    return '$dateまで';
  }

  @override
  String get weeklyRule => 'ヒントなしのクリアのみランキングに登録されます';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'クリア $done/$total';
  }

  @override
  String get weeklyChallenge => '挑戦';

  @override
  String get weeklyRetry => '再挑戦';

  @override
  String get weeklyNotPlayed => 'まだ挑戦していません';

  @override
  String get weeklyInProgress => '挑戦中';

  @override
  String get weeklyNoLeader => 'まだ1位はいません';

  @override
  String get weeklyLoadFailed => 'ランキングを読み込めませんでした';

  @override
  String get retry => '再試行';

  @override
  String get weeklyYouAreFirst => 'あなたが1位！';

  @override
  String weeklyMyBest(String time) {
    return '今週の自己ベスト $time';
  }

  @override
  String get weeklySending => '送信中 — オンラインになると自動で完了します';

  @override
  String get weeklyRank1 => '今週の1位！';

  @override
  String get weeklyHintExcluded => 'ヒントを使用したため今週のランキング対象外です';

  @override
  String get weeklyLastWeek => '先週のパズルのため記録されません';

  @override
  String get rankingExcluded => 'ランキング対象外';

  @override
  String get anonymous => '匿名';

  @override
  String get weeklyReport => '不適切なニックネームを報告';

  @override
  String get nickname => 'ニックネーム';

  @override
  String get nicknameSet => 'ニックネームを設定';

  @override
  String get nicknameChange => '変更';

  @override
  String get nicknameHelper => 'ランキングに公開されます';

  @override
  String get nicknameTooShort => '2文字以上入力してください';

  @override
  String get nicknameInvalid => '文字、数字、スペース、_ のみ使えます';

  @override
  String get nicknameBanned => 'このニックネームは使用できません';

  @override
  String get save => '保存';
}
