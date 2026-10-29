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
}
