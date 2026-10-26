// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Nyugodt összpontosítás, napi pihenő az elmének';

  @override
  String get newGame => 'Új játék';

  @override
  String get records => 'Eredmények';

  @override
  String get settings => 'Beállítások';

  @override
  String get continueTitle => 'Folyamatban lévő játék';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString kész · $time telt el';
  }

  @override
  String get overwriteTitle => 'Új játékot kezdesz?';

  @override
  String get overwriteBody => 'A folyamatban lévő játék elveszik.';

  @override
  String get saveIncompatible =>
      'Egy régebbi verzióból mentett játékot nem lehetett folytatni, ezért töröltük.';

  @override
  String get cancel => 'Mégse';

  @override
  String get removeAds => 'Reklámok eltávolítása';

  @override
  String removeAdsWithPrice(String price) {
    return 'Reklámok eltávolítása $price';
  }

  @override
  String get removeAdsDesc => 'Egyetlen vásárlás, örökre reklám nélkül';

  @override
  String get removeAdsLongDesc =>
      'Egyetlen vásárlással végleg eltávolíthatsz minden reklámot, és teljesen a feladványra figyelhetsz.';

  @override
  String get adsRemoved => 'Reklámok eltávolítva';

  @override
  String get purchasePending => 'Feldolgozás';

  @override
  String get storeUnavailable => 'Nem sikerült csatlakozni az áruházhoz';

  @override
  String get restorePurchases => 'Vásárlások visszaállítása';

  @override
  String get restoreRequested => 'Vásárlási előzmények ellenőrzése';

  @override
  String get purchaseFailed => 'A fizetés nem sikerült. Próbáld újra később';

  @override
  String get restoreFailed =>
      'A vásárlások visszaállítása nem sikerült. Próbáld újra később';

  @override
  String get restoreNone => 'Nincs visszaállítható vásárlás';

  @override
  String get resultRemoveAdsLine => 'Reklám nélkül játszanál?';

  @override
  String get chooseDifficulty => 'Nehézség kiválasztása';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          '$max hiba után vége a játéknak · A visszavonás nem csökkenti a hibákat',
      one:
          '$max hiba után vége a játéknak · A visszavonás nem csökkenti a hibákat',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Mindjárt kezdünk';

  @override
  String get preparingSub => 'Új feladvány készül…';

  @override
  String get puzzleFailed => 'Nem sikerült feladványt készíteni. Próbáld újra';

  @override
  String get back => 'Vissza';

  @override
  String get more => 'Továbbiak';

  @override
  String get restartSame => 'Újrakezdés';

  @override
  String get restartConfirmTitle => 'Elölről kezded ezt a feladványt?';

  @override
  String get restartConfirmBody =>
      'A beírt számok, az idő és a hibák is nullázódnak.';

  @override
  String get instantCheck => 'Azonnali ellenőrzés';

  @override
  String mistakes(int count, int max) {
    return 'Hibák $count/$max';
  }

  @override
  String get undo => 'Visszavon';

  @override
  String get erase => 'Törlés';

  @override
  String get memo => 'Jegyzet';

  @override
  String get memoOn => 'Jegyzet BE';

  @override
  String get mistakeKept => 'A visszavonás nem csökkenti a hibák számát';

  @override
  String cellEmpty(int row, int column) {
    return '$row. sor, $column. oszlop, üres';
  }

  @override
  String cellValue(int row, int column, int value) {
    return '$row. sor, $column. oszlop, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, még $count';
  }

  @override
  String get cleared => 'Megoldva!';

  @override
  String get gameOver => 'Vége a játéknak';

  @override
  String clearedSub(String difficulty) {
    return 'Teljesítetted a(z) $difficulty szintet';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Elérted a(z) $max hibát',
      one: 'Elérted a(z) $max hibát',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Új rekord';

  @override
  String get time => 'Idő';

  @override
  String get mistakeCount => 'Hibák';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alkalom',
      one: '$count alkalom',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Nehézség';

  @override
  String get home => 'Főoldal';

  @override
  String get all => 'Mind';

  @override
  String get bestRecords => 'Legjobb idők';

  @override
  String get bestRecordsSub => 'Leggyorsabb idő nehézségenként';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Legutóbbi játékok ($count)',
      one: 'Legutóbbi játék ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Még nincs eredmény';

  @override
  String get noRecordsSub => 'Oldj meg egy feladványt, és itt megjelenik';

  @override
  String get clearTime => 'Megoldási idő';

  @override
  String get checkOff => 'Ellenőrzés ki';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hiba',
      one: '$count hiba',
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
  String get clearAll => 'Összes törlése';

  @override
  String get clearAllTitle => 'Törlöd az összes eredményt?';

  @override
  String get clearAllBody => 'A törölt eredmények nem állíthatók vissza.';

  @override
  String get delete => 'Törlés';

  @override
  String get instantCheckDefault => 'Azonnali ellenőrzés alapból';

  @override
  String get instantCheckDesc => 'A hibás számokat beíráskor azonnal jelzi';

  @override
  String get privacyOptions => 'Adatvédelmi beállítások';

  @override
  String get privacyOptionsDesc =>
      'A hirdetési hozzájárulás beállításainak megtekintése vagy módosítása';

  @override
  String get privacyPolicy => 'Adatvédelmi irányelvek';

  @override
  String get openLinkFailed => 'Nem sikerült megnyitni a linket';

  @override
  String get appVersion => 'Alkalmazásverzió';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Könnyű';

  @override
  String get difficultyNormal => 'Közepes';

  @override
  String get difficultyHard => 'Nehéz';

  @override
  String get difficultyExpert => 'Szakértő';

  @override
  String get difficultyHell => 'Pokoli';
}
