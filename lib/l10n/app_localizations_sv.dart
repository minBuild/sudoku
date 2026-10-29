// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Lugnt fokus, en daglig paus för tankarna';

  @override
  String get newGame => 'Nytt spel';

  @override
  String get records => 'Historik';

  @override
  String get settings => 'Inställningar';

  @override
  String get continueTitle => 'Pågående spel';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString klart · $time har gått';
  }

  @override
  String get overwriteTitle => 'Starta ett nytt spel?';

  @override
  String get overwriteBody => 'Det pågående spelet går förlorat.';

  @override
  String get saveIncompatible =>
      'Ett sparat spel från en äldre version kunde inte återupptas och har raderats.';

  @override
  String get cancel => 'Avbryt';

  @override
  String get removeAds => 'Ta bort annonser';

  @override
  String removeAdsWithPrice(String price) {
    return 'Ta bort annonser $price';
  }

  @override
  String get removeAdsDesc => 'Ett köp, annonsfritt för alltid';

  @override
  String get removeAdsLongDesc =>
      'Ta bort alla annonser permanent med ett enda köp och fokusera helt på pusslet.';

  @override
  String get adsRemoved => 'Annonser borttagna';

  @override
  String get purchasePending => 'Bearbetar';

  @override
  String get storeUnavailable => 'Kan inte ansluta till butiken';

  @override
  String get restorePurchases => 'Återställ köp';

  @override
  String get restoreRequested => 'Kontrollerar din köphistorik';

  @override
  String get purchaseFailed =>
      'Betalningen kunde inte slutföras. Försök igen senare';

  @override
  String get restoreFailed =>
      'Köpen kunde inte återställas. Försök igen senare';

  @override
  String get restoreNone => 'Inga köp att återställa';

  @override
  String get resultRemoveAdsLine => 'Vill du spela utan annonser?';

  @override
  String get chooseDifficulty => 'Välj svårighetsgrad';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Spelet är slut efter $max fel · Ångra minskar inte felen',
      one: 'Spelet är slut efter $max fel · Ångra minskar inte felen',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Strax börjar vi';

  @override
  String get preparingSub => 'Skapar ett nytt pussel…';

  @override
  String get puzzleFailed => 'Kunde inte skapa ett pussel. Försök igen';

  @override
  String get back => 'Tillbaka';

  @override
  String get more => 'Mer';

  @override
  String get restartSame => 'Börja om';

  @override
  String get restartConfirmTitle => 'Börja om det här pusslet från början?';

  @override
  String get restartConfirmBody => 'Inmatningar, tid och fel nollställs.';

  @override
  String get instantCheck => 'Direktkontroll';

  @override
  String mistakes(int count, int max) {
    return 'Fel $count/$max';
  }

  @override
  String get undo => 'Ångra';

  @override
  String get erase => 'Sudda';

  @override
  String get memo => 'Anteckningar';

  @override
  String get memoOn => 'Anteckningar PÅ';

  @override
  String get mistakeKept => 'Ångra minskar inte antalet fel';

  @override
  String cellEmpty(int row, int column) {
    return 'Rad $row, kolumn $column, tom';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Rad $row, kolumn $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, $count kvar';
  }

  @override
  String get cleared => 'Löst!';

  @override
  String get gameOver => 'Spelet är slut';

  @override
  String clearedSub(String difficulty) {
    return 'Du klarade nivån $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Du nådde $max fel',
      one: 'Du nådde $max fel',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Nytt rekord';

  @override
  String get time => 'Tid';

  @override
  String get mistakeCount => 'Fel';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gånger',
      one: '$count gång',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Nivå';

  @override
  String get home => 'Hem';

  @override
  String get all => 'Alla';

  @override
  String get bestRecords => 'Bästa tider';

  @override
  String get bestRecordsSub => 'Snabbaste tid per svårighetsgrad';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Senaste spel ($count)',
      one: 'Senaste spel ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Inga spel än';

  @override
  String get noRecordsSub => 'Lös ett pussel för att se det här';

  @override
  String get clearTime => 'Lösningstid';

  @override
  String get checkOff => 'Utan kontroll';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fel',
      one: '$count fel',
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
  String get clearAll => 'Radera alla';

  @override
  String get clearAllTitle => 'Radera all historik?';

  @override
  String get clearAllBody => 'Raderade spel kan inte återställas.';

  @override
  String get delete => 'Radera';

  @override
  String get instantCheckDefault => 'Direktkontroll som standard';

  @override
  String get instantCheckDesc =>
      'Visa felaktiga siffror direkt när de matas in';

  @override
  String get soundEffects => 'Ljudeffekter';

  @override
  String get soundEffectsDesc => 'Ljud för inmatning, fel och slutförande';

  @override
  String get privacyOptions => 'Integritetsalternativ';

  @override
  String get privacyOptionsDesc =>
      'Granska eller ändra dina inställningar för annonssamtycke';

  @override
  String get privacyPolicy => 'Integritetspolicy';

  @override
  String get openLinkFailed => 'Länken kunde inte öppnas';

  @override
  String get appVersion => 'Appversion';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Lätt';

  @override
  String get difficultyNormal => 'Medel';

  @override
  String get difficultyHard => 'Svår';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyHell => 'Helvete';

  @override
  String get hint => 'Ledtråd';

  @override
  String get hintUse => 'Använd ledtråd';

  @override
  String get hintRankingWarn =>
      'Om du använder en ledtråd räknas spelet inte med i veckans topplista';

  @override
  String get rewardHintTitle => 'Se en annons för en ledtråd';

  @override
  String get rewardHintBody =>
      'Se en kort annons till slutet för att få 1 ledtråd. Gratis ledtrådar fylls på till 3 igen i morgon.';

  @override
  String get rewardContinueBody =>
      'Se en kort annons till slutet för att nollställa misstagen och spela vidare.';

  @override
  String get watchAd => 'Se annons';

  @override
  String get adLoading => 'Läser in annons…';

  @override
  String get adUnavailable => 'Kan inte läsa in någon annons just nu';

  @override
  String get adNotCompleted => 'Se annonsen till slutet för att få belöningen';

  @override
  String get continueAfterFail => 'Spela vidare';

  @override
  String get continueWithAd => 'Se annons och spela vidare';

  @override
  String get weeklyTitle => 'Veckans utmaning';

  @override
  String weeklyWeekLabel(int week) {
    return 'Vecka $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Till $date';
  }

  @override
  String get weeklyRule =>
      'Bara lösningar utan ledtrådar kommer med på topplistan';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Löst $done/$total';
  }

  @override
  String get weeklyChallenge => 'Spela';

  @override
  String get weeklyRetry => 'Spela igen';

  @override
  String get weeklyNotPlayed => 'Inte spelat än';

  @override
  String get weeklyInProgress => 'Pågår';

  @override
  String get weeklyNoLeader => 'Ingen etta än';

  @override
  String get weeklyLoadFailed => 'Kunde inte läsa in topplistan';

  @override
  String get retry => 'Försök igen';

  @override
  String get weeklyYouAreFirst => 'Du är etta!';

  @override
  String weeklyMyBest(String time) {
    return 'Min bästa tid i veckan $time';
  }

  @override
  String get weeklySending => 'Skickar — slutförs när du är online';

  @override
  String get weeklyRank1 => 'Etta i veckan!';

  @override
  String get weeklyHintExcluded => 'Ledtråd använd — ingen placering i veckan';

  @override
  String get weeklyLastWeek => 'Förra veckans pussel — registrerades inte';

  @override
  String get rankingExcluded => 'Ej rankad';

  @override
  String get anonymous => 'Anonym';

  @override
  String get weeklyReport => 'Anmäl ett smeknamn';

  @override
  String get nickname => 'Smeknamn';

  @override
  String get nicknameSet => 'Ange smeknamn';

  @override
  String get nicknameChange => 'Ändra';

  @override
  String get nicknameHelper => 'Visas på topplistan';

  @override
  String get nicknameTooShort => 'Använd minst 2 tecken';

  @override
  String get nicknameInvalid => 'Bara bokstäver, siffror, mellanslag och _';

  @override
  String get nicknameBanned => 'Det här smeknamnet är inte tillåtet';

  @override
  String get save => 'Spara';
}
