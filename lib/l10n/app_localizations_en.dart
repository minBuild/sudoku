// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Calm focus, a daily break for your mind';

  @override
  String get newGame => 'New Game';

  @override
  String get records => 'Records';

  @override
  String get settings => 'Settings';

  @override
  String get continueTitle => 'Game in progress';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString complete · $time elapsed';
  }

  @override
  String get overwriteTitle => 'Start a new game?';

  @override
  String get overwriteBody => 'Your game in progress will be lost.';

  @override
  String get saveIncompatible =>
      'A saved game from an older version couldn\'t be resumed, so it was deleted.';

  @override
  String get cancel => 'Cancel';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String removeAdsWithPrice(String price) {
    return 'Remove Ads $price';
  }

  @override
  String get removeAdsDesc => 'One purchase, no ads forever';

  @override
  String get removeAdsLongDesc =>
      'Remove all ads permanently with a single purchase and focus fully on the puzzle.';

  @override
  String get adsRemoved => 'Ads removed';

  @override
  String get purchasePending => 'Processing';

  @override
  String get storeUnavailable => 'Can\'t connect to the store';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get restoreRequested => 'Checking your purchase history';

  @override
  String get purchaseFailed =>
      'Couldn\'t complete the payment. Please try again later';

  @override
  String get restoreFailed =>
      'Couldn\'t restore purchases. Please try again later';

  @override
  String get restoreNone => 'No purchases to restore';

  @override
  String get resultRemoveAdsLine => 'Want to play without ads?';

  @override
  String get chooseDifficulty => 'Choose Difficulty';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Game over after $max mistakes · Undo doesn\'t reduce mistakes',
      one: 'Game over after $max mistake · Undo doesn\'t reduce mistakes',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Starting shortly';

  @override
  String get preparingSub => 'Generating a new puzzle…';

  @override
  String get puzzleFailed => 'Couldn\'t create a puzzle. Please try again';

  @override
  String get back => 'Back';

  @override
  String get more => 'More';

  @override
  String get restartSame => 'Restart Puzzle';

  @override
  String get restartConfirmTitle => 'Restart this puzzle from the beginning?';

  @override
  String get restartConfirmBody =>
      'Your entries, time, and mistakes will all be reset.';

  @override
  String get instantCheck => 'Instant Check';

  @override
  String mistakes(int count, int max) {
    return 'Mistakes $count/$max';
  }

  @override
  String get undo => 'Undo';

  @override
  String get erase => 'Erase';

  @override
  String get memo => 'Notes';

  @override
  String get memoOn => 'Notes ON';

  @override
  String get mistakeKept => 'Undo doesn\'t reduce the mistake count';

  @override
  String cellEmpty(int row, int column) {
    return 'Row $row, column $column, empty';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Row $row, column $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, $count left';
  }

  @override
  String get cleared => 'Solved!';

  @override
  String get gameOver => 'Game Over';

  @override
  String clearedSub(String difficulty) {
    return 'You cleared $difficulty difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'You reached $max mistakes',
      one: 'You reached $max mistake',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 New Best';

  @override
  String get time => 'Time';

  @override
  String get mistakeCount => 'Mistakes';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: '$count time',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Difficulty';

  @override
  String get home => 'Home';

  @override
  String get all => 'All';

  @override
  String get bestRecords => 'Best Times';

  @override
  String get bestRecordsSub => 'Fastest clear time per difficulty';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Recent records ($count)',
      one: 'Recent record ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'No records yet';

  @override
  String get noRecordsSub => 'Clear a puzzle to see it here';

  @override
  String get clearTime => 'Clear Time';

  @override
  String get checkOff => 'No Check';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mistakes',
      one: '$count mistake',
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
  String get clearAll => 'Delete All';

  @override
  String get clearAllTitle => 'Delete all records?';

  @override
  String get clearAllBody => 'Deleted records can\'t be recovered.';

  @override
  String get delete => 'Delete';

  @override
  String get instantCheckDefault => 'Instant Check by Default';

  @override
  String get instantCheckDesc => 'Show wrong entries as soon as you enter them';

  @override
  String get soundEffects => 'Sound effects';

  @override
  String get soundEffectsDesc => 'Input, mistake and clear sounds';

  @override
  String get privacyOptions => 'Privacy Options';

  @override
  String get privacyOptionsDesc => 'Review or change your ad consent settings';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get openLinkFailed => 'Couldn\'t open the link';

  @override
  String get appVersion => 'App Version';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyHell => 'Hell';

  @override
  String get hint => 'Hint';

  @override
  String get hintUse => 'Use hint';

  @override
  String get hintRankingWarn =>
      'Using a hint removes this game from this week\'s ranking';

  @override
  String get rewardHintTitle => 'Watch an ad for a hint';

  @override
  String get rewardHintBody =>
      'Watch a short ad to the end to get 1 hint. Free hints refill to 3 tomorrow.';

  @override
  String get rewardContinueBody =>
      'Watch a short ad to the end to reset mistakes and keep playing.';

  @override
  String get watchAd => 'Watch ad';

  @override
  String get adLoading => 'Loading ad…';

  @override
  String get adUnavailable => 'Can\'t load an ad right now';

  @override
  String get adNotCompleted => 'Watch the ad to the end to get the reward';

  @override
  String get continueAfterFail => 'Keep playing';

  @override
  String get continueWithAd => 'Watch ad to keep playing';

  @override
  String get weeklyTitle => 'Weekly challenge';

  @override
  String weeklyWeekLabel(int week) {
    return 'Week $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Until $date';
  }

  @override
  String get weeklyRule => 'Only clears without hints are ranked';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Cleared $done/$total';
  }

  @override
  String get weeklyChallenge => 'Play';

  @override
  String get weeklyRetry => 'Try again';

  @override
  String get weeklyNotPlayed => 'Not played yet';

  @override
  String get weeklyInProgress => 'In progress';

  @override
  String get weeklyNoLeader => 'No leader yet';

  @override
  String get weeklyLoadFailed => 'Couldn\'t load rankings';

  @override
  String get retry => 'Retry';

  @override
  String get weeklyYouAreFirst => 'You\'re #1!';

  @override
  String weeklyMyBest(String time) {
    return 'My best this week $time';
  }

  @override
  String get weeklySending => 'Sending — will finish when you\'re online';

  @override
  String get weeklyRank1 => '#1 this week!';

  @override
  String get weeklyHintExcluded => 'Hint used — not ranked this week';

  @override
  String get weeklyLastWeek => 'Last week\'s puzzle — not recorded';

  @override
  String get rankingExcluded => 'Not ranked';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get weeklyReport => 'Report a nickname';

  @override
  String get nickname => 'Nickname';

  @override
  String get nicknameSet => 'Set nickname';

  @override
  String get nicknameChange => 'Change';

  @override
  String get nicknameHelper => 'Shown on the leaderboard';

  @override
  String get nicknameTooShort => 'Use at least 2 characters';

  @override
  String get nicknameInvalid => 'Letters, numbers, spaces and _ only';

  @override
  String get nicknameBanned => 'This nickname isn\'t allowed';

  @override
  String get save => 'Save';
}
