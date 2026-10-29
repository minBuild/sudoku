// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline =>
      'Ruhige Konzentration, eine tägliche Pause für den Kopf';

  @override
  String get newGame => 'Neues Spiel';

  @override
  String get records => 'Statistik';

  @override
  String get settings => 'Einstellungen';

  @override
  String get continueTitle => 'Laufendes Spiel';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString gelöst · $time vergangen';
  }

  @override
  String get overwriteTitle => 'Neues Spiel starten?';

  @override
  String get overwriteBody => 'Das laufende Spiel geht verloren.';

  @override
  String get saveIncompatible =>
      'Ein gespeichertes Spiel aus einer älteren Version konnte nicht fortgesetzt werden und wurde gelöscht.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get removeAds => 'Werbung entfernen';

  @override
  String removeAdsWithPrice(String price) {
    return 'Werbung entfernen $price';
  }

  @override
  String get removeAdsDesc => 'Einmal kaufen, für immer werbefrei';

  @override
  String get removeAdsLongDesc =>
      'Entferne alle Werbung dauerhaft mit einem einzigen Kauf und konzentriere dich ganz auf das Rätsel.';

  @override
  String get adsRemoved => 'Werbung entfernt';

  @override
  String get purchasePending => 'Wird verarbeitet';

  @override
  String get storeUnavailable => 'Keine Verbindung zum Store';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get restoreRequested => 'Deine Käufe werden geprüft';

  @override
  String get purchaseFailed =>
      'Die Zahlung konnte nicht abgeschlossen werden. Bitte versuche es später erneut';

  @override
  String get restoreFailed =>
      'Käufe konnten nicht wiederhergestellt werden. Bitte versuche es später erneut';

  @override
  String get restoreNone => 'Keine Käufe zum Wiederherstellen';

  @override
  String get resultRemoveAdsLine => 'Lieber ohne Werbung spielen?';

  @override
  String get chooseDifficulty => 'Schwierigkeit wählen';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Nach $max Fehlern ist das Spiel vorbei · Rückgängig verringert die Fehler nicht',
      one:
          'Nach $max Fehler ist das Spiel vorbei · Rückgängig verringert die Fehler nicht',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Gleich geht\'s los';

  @override
  String get preparingSub => 'Neues Rätsel wird erstellt…';

  @override
  String get puzzleFailed =>
      'Rätsel konnte nicht erstellt werden. Bitte versuche es erneut';

  @override
  String get back => 'Zurück';

  @override
  String get more => 'Mehr';

  @override
  String get restartSame => 'Neu starten';

  @override
  String get restartConfirmTitle => 'Dieses Rätsel von vorn beginnen?';

  @override
  String get restartConfirmBody =>
      'Eingaben, Zeit und Fehler werden zurückgesetzt.';

  @override
  String get instantCheck => 'Sofortprüfung';

  @override
  String mistakes(int count, int max) {
    return 'Fehler $count/$max';
  }

  @override
  String get undo => 'Rückgängig';

  @override
  String get erase => 'Löschen';

  @override
  String get memo => 'Notizen';

  @override
  String get memoOn => 'Notizen AN';

  @override
  String get mistakeKept => 'Rückgängig verringert die Fehlerzahl nicht';

  @override
  String cellEmpty(int row, int column) {
    return 'Zeile $row, Spalte $column, leer';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Zeile $row, Spalte $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, noch $count';
  }

  @override
  String get cleared => 'Gelöst!';

  @override
  String get gameOver => 'Spiel vorbei';

  @override
  String clearedSub(String difficulty) {
    return 'Du hast die Stufe $difficulty geschafft';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Du hast $max Fehler erreicht',
      one: 'Du hast $max Fehler erreicht',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Neue Bestzeit';

  @override
  String get time => 'Zeit';

  @override
  String get mistakeCount => 'Fehler';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-mal',
      one: '$count-mal',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Stufe';

  @override
  String get home => 'Start';

  @override
  String get all => 'Alle';

  @override
  String get bestRecords => 'Bestzeiten';

  @override
  String get bestRecordsSub => 'Schnellste Zeit pro Schwierigkeit';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Letzte Spiele ($count)',
      one: 'Letztes Spiel ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Noch keine Einträge';

  @override
  String get noRecordsSub => 'Löse ein Rätsel, um es hier zu sehen';

  @override
  String get clearTime => 'Lösungszeit';

  @override
  String get checkOff => 'Ohne Prüfung';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fehler',
      one: '$count Fehler',
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
  String get clearAll => 'Alle löschen';

  @override
  String get clearAllTitle => 'Alle Einträge löschen?';

  @override
  String get clearAllBody =>
      'Gelöschte Einträge können nicht wiederhergestellt werden.';

  @override
  String get delete => 'Löschen';

  @override
  String get instantCheckDefault => 'Sofortprüfung standardmäßig';

  @override
  String get instantCheckDesc => 'Falsche Eingaben sofort anzeigen';

  @override
  String get soundEffects => 'Soundeffekte';

  @override
  String get soundEffectsDesc => 'Töne für Eingabe, Fehler und Abschluss';

  @override
  String get privacyOptions => 'Datenschutzoptionen';

  @override
  String get privacyOptionsDesc =>
      'Einwilligungseinstellungen für Werbung prüfen oder ändern';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get openLinkFailed => 'Link konnte nicht geöffnet werden';

  @override
  String get appVersion => 'App-Version';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Leicht';

  @override
  String get difficultyNormal => 'Mittel';

  @override
  String get difficultyHard => 'Schwer';

  @override
  String get difficultyExpert => 'Experte';

  @override
  String get difficultyHell => 'Hölle';

  @override
  String get hint => 'Tipp';

  @override
  String get hintUse => 'Tipp nutzen';

  @override
  String get hintRankingWarn =>
      'Mit einem Tipp zählt dieses Spiel nicht für die Rangliste dieser Woche';

  @override
  String get rewardHintTitle => 'Werbung ansehen für einen Tipp';

  @override
  String get rewardHintBody =>
      'Sieh dir eine kurze Werbung bis zum Ende an und erhalte 1 Tipp. Kostenlose Tipps werden morgen wieder auf 3 aufgefüllt.';

  @override
  String get rewardContinueBody =>
      'Sieh dir eine kurze Werbung bis zum Ende an, um die Fehler zurückzusetzen und weiterzuspielen.';

  @override
  String get watchAd => 'Werbung ansehen';

  @override
  String get adLoading => 'Werbung wird geladen…';

  @override
  String get adUnavailable => 'Werbung kann gerade nicht geladen werden';

  @override
  String get adNotCompleted =>
      'Sieh dir die Werbung bis zum Ende an, um die Belohnung zu erhalten';

  @override
  String get continueAfterFail => 'Weiterspielen';

  @override
  String get continueWithAd => 'Mit Werbung weiterspielen';

  @override
  String get weeklyTitle => 'Wochen-Challenge';

  @override
  String weeklyWeekLabel(int week) {
    return 'Woche $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Bis $date';
  }

  @override
  String get weeklyRule => 'Nur Lösungen ohne Tipps kommen in die Rangliste';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Gelöst $done/$total';
  }

  @override
  String get weeklyChallenge => 'Spielen';

  @override
  String get weeklyRetry => 'Erneut spielen';

  @override
  String get weeklyNotPlayed => 'Noch nicht gespielt';

  @override
  String get weeklyInProgress => 'Läuft';

  @override
  String get weeklyNoLeader => 'Noch niemand auf Platz 1';

  @override
  String get weeklyLoadFailed => 'Rangliste konnte nicht geladen werden';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get weeklyYouAreFirst => 'Du bist Platz 1!';

  @override
  String weeklyMyBest(String time) {
    return 'Meine Bestzeit diese Woche $time';
  }

  @override
  String get weeklySending =>
      'Wird gesendet — wird abgeschlossen, sobald du online bist';

  @override
  String get weeklyRank1 => 'Platz 1 diese Woche!';

  @override
  String get weeklyHintExcluded => 'Tipp genutzt — diese Woche nicht gewertet';

  @override
  String get weeklyLastWeek => 'Rätsel der letzten Woche — nicht gewertet';

  @override
  String get rankingExcluded => 'Nicht gewertet';

  @override
  String get anonymous => 'Anonym';

  @override
  String get weeklyReport => 'Spitznamen melden';

  @override
  String get nickname => 'Spitzname';

  @override
  String get nicknameSet => 'Spitzname festlegen';

  @override
  String get nicknameChange => 'Ändern';

  @override
  String get nicknameHelper => 'Wird in der Rangliste angezeigt';

  @override
  String get nicknameTooShort => 'Mindestens 2 Zeichen eingeben';

  @override
  String get nicknameInvalid => 'Nur Buchstaben, Zahlen, Leerzeichen und _';

  @override
  String get nicknameBanned => 'Dieser Spitzname ist nicht erlaubt';

  @override
  String get save => 'Speichern';
}
