// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Pokojné sústredenie, každodenný oddych pre myseľ';

  @override
  String get newGame => 'Nová hra';

  @override
  String get records => 'Záznamy';

  @override
  String get settings => 'Nastavenia';

  @override
  String get continueTitle => 'Rozohratá hra';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'Hotovo $progressString · uplynulo $time';
  }

  @override
  String get overwriteTitle => 'Začať novú hru?';

  @override
  String get overwriteBody => 'Rozohratá hra sa stratí.';

  @override
  String get saveIncompatible =>
      'Uloženú hru zo staršej verzie sa nepodarilo obnoviť, preto bola odstránená.';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get removeAds => 'Odstrániť reklamy';

  @override
  String removeAdsWithPrice(String price) {
    return 'Odstrániť reklamy $price';
  }

  @override
  String get removeAdsDesc => 'Jeden nákup, navždy bez reklám';

  @override
  String get removeAdsLongDesc =>
      'Jediným nákupom natrvalo odstránite všetky reklamy a naplno sa sústredíte na hádanku.';

  @override
  String get adsRemoved => 'Reklamy odstránené';

  @override
  String get purchasePending => 'Spracúva sa';

  @override
  String get storeUnavailable => 'Nedá sa pripojiť k obchodu';

  @override
  String get restorePurchases => 'Obnoviť nákupy';

  @override
  String get restoreRequested => 'Kontrolujeme históriu nákupov';

  @override
  String get purchaseFailed =>
      'Platbu sa nepodarilo dokončiť. Skúste to neskôr';

  @override
  String get restoreFailed => 'Nákupy sa nepodarilo obnoviť. Skúste to neskôr';

  @override
  String get restoreNone => 'Žiadne nákupy na obnovenie';

  @override
  String get resultRemoveAdsLine => 'Chcete hrať bez reklám?';

  @override
  String get chooseDifficulty => 'Vyberte obťažnosť';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Hra končí po $max chybách · Späť počet chýb neznižuje',
      many: 'Hra končí po $max chybách · Späť počet chýb neznižuje',
      few: 'Hra končí po $max chybách · Späť počet chýb neznižuje',
      one: 'Hra končí po $max chybe · Späť počet chýb neznižuje',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'O chvíľu začíname';

  @override
  String get preparingSub => 'Vytvárame novú hádanku…';

  @override
  String get puzzleFailed => 'Hádanku sa nepodarilo vytvoriť. Skúste to znova';

  @override
  String get back => 'Späť';

  @override
  String get more => 'Viac';

  @override
  String get restartSame => 'Začať znova';

  @override
  String get restartConfirmTitle => 'Začať túto hádanku od začiatku?';

  @override
  String get restartConfirmBody => 'Zadané čísla, čas aj chyby sa vynulujú.';

  @override
  String get instantCheck => 'Okamžitá kontrola';

  @override
  String mistakes(int count, int max) {
    return 'Chyby $count/$max';
  }

  @override
  String get undo => 'Vrátiť';

  @override
  String get erase => 'Vymazať';

  @override
  String get memo => 'Poznámky';

  @override
  String get memoOn => 'Poznámky ZAP';

  @override
  String get mistakeKept => 'Vrátenie ťahu počet chýb neznižuje';

  @override
  String cellEmpty(int row, int column) {
    return 'Riadok $row, stĺpec $column, prázdne';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Riadok $row, stĺpec $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, zostáva $count';
  }

  @override
  String get cleared => 'Vyriešené!';

  @override
  String get gameOver => 'Koniec hry';

  @override
  String clearedSub(String difficulty) {
    return 'Zvládli ste obťažnosť $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Dosiahli ste $max chýb',
      many: 'Dosiahli ste $max chýb',
      few: 'Dosiahli ste $max chyby',
      one: 'Dosiahli ste $max chybu',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Nový rekord';

  @override
  String get time => 'Čas';

  @override
  String get mistakeCount => 'Chyby';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count×',
      many: '$count×',
      few: '$count×',
      one: '$count×',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Obťažnosť';

  @override
  String get home => 'Domov';

  @override
  String get all => 'Všetko';

  @override
  String get bestRecords => 'Najlepšie časy';

  @override
  String get bestRecordsSub => 'Najrýchlejší čas pre každú obťažnosť';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nedávne hry ($count)',
      many: 'Nedávne hry ($count)',
      few: 'Nedávne hry ($count)',
      one: 'Nedávna hra ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Zatiaľ žiadne záznamy';

  @override
  String get noRecordsSub => 'Vyriešte hádanku a uvidíte ju tu';

  @override
  String get clearTime => 'Čas riešenia';

  @override
  String get checkOff => 'Bez kontroly';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chýb',
      many: '$count chyby',
      few: '$count chyby',
      one: '$count chyba',
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
  String get clearAll => 'Vymazať všetko';

  @override
  String get clearAllTitle => 'Vymazať všetky záznamy?';

  @override
  String get clearAllBody => 'Vymazané záznamy sa nedajú obnoviť.';

  @override
  String get delete => 'Vymazať';

  @override
  String get instantCheckDefault => 'Okamžitá kontrola predvolene';

  @override
  String get instantCheckDesc => 'Nesprávne zadanie zobraziť hneď';

  @override
  String get privacyOptions => 'Možnosti ochrany súkromia';

  @override
  String get privacyOptionsDesc =>
      'Skontrolujte alebo zmeňte nastavenia súhlasu s reklamami';

  @override
  String get privacyPolicy => 'Zásady ochrany osobných údajov';

  @override
  String get openLinkFailed => 'Odkaz sa nedá otvoriť';

  @override
  String get appVersion => 'Verzia aplikácie';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Ľahká';

  @override
  String get difficultyNormal => 'Stredná';

  @override
  String get difficultyHard => 'Ťažká';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyHell => 'Peklo';
}
