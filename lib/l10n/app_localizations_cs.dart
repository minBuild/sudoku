// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Klidné soustředění, každodenní odpočinek pro mysl';

  @override
  String get newGame => 'Nová hra';

  @override
  String get records => 'Záznamy';

  @override
  String get settings => 'Nastavení';

  @override
  String get continueTitle => 'Rozehraná hra';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'Hotovo $progressString · uplynulo $time';
  }

  @override
  String get overwriteTitle => 'Začít novou hru?';

  @override
  String get overwriteBody => 'Rozehraná hra bude ztracena.';

  @override
  String get saveIncompatible =>
      'Uloženou hru ze starší verze nebylo možné obnovit, proto byla smazána.';

  @override
  String get cancel => 'Zrušit';

  @override
  String get removeAds => 'Odstranit reklamy';

  @override
  String removeAdsWithPrice(String price) {
    return 'Odstranit reklamy $price';
  }

  @override
  String get removeAdsDesc => 'Jeden nákup, navždy bez reklam';

  @override
  String get removeAdsLongDesc =>
      'Jediným nákupem trvale odstraníte všechny reklamy a plně se soustředíte na hádanku.';

  @override
  String get adsRemoved => 'Reklamy odstraněny';

  @override
  String get purchasePending => 'Zpracovává se';

  @override
  String get storeUnavailable => 'Nelze se připojit k obchodu';

  @override
  String get restorePurchases => 'Obnovit nákupy';

  @override
  String get restoreRequested => 'Kontrolujeme historii nákupů';

  @override
  String get purchaseFailed =>
      'Platbu se nepodařilo dokončit. Zkuste to prosím později';

  @override
  String get restoreFailed =>
      'Nákupy se nepodařilo obnovit. Zkuste to prosím později';

  @override
  String get restoreNone => 'Žádné nákupy k obnovení';

  @override
  String get resultRemoveAdsLine => 'Chcete hrát bez reklam?';

  @override
  String get chooseDifficulty => 'Vyberte obtížnost';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Hra končí po $max chybách · Zpět počet chyb nesníží',
      many: 'Hra končí po $max chybách · Zpět počet chyb nesníží',
      few: 'Hra končí po $max chybách · Zpět počet chyb nesníží',
      one: 'Hra končí po $max chybě · Zpět počet chyb nesníží',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Za chvíli začínáme';

  @override
  String get preparingSub => 'Vytváříme novou hádanku…';

  @override
  String get puzzleFailed => 'Hádanku se nepodařilo vytvořit. Zkuste to znovu';

  @override
  String get back => 'Zpět';

  @override
  String get more => 'Více';

  @override
  String get restartSame => 'Začít znovu';

  @override
  String get restartConfirmTitle => 'Začít tuto hádanku od začátku?';

  @override
  String get restartConfirmBody => 'Zadaná čísla, čas i chyby se vynulují.';

  @override
  String get instantCheck => 'Okamžitá kontrola';

  @override
  String mistakes(int count, int max) {
    return 'Chyby $count/$max';
  }

  @override
  String get undo => 'Vrátit';

  @override
  String get erase => 'Smazat';

  @override
  String get memo => 'Poznámky';

  @override
  String get memoOn => 'Poznámky ZAP';

  @override
  String get mistakeKept => 'Vrácení tahu počet chyb nesníží';

  @override
  String cellEmpty(int row, int column) {
    return 'Řádek $row, sloupec $column, prázdné';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Řádek $row, sloupec $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, zbývá $count';
  }

  @override
  String get cleared => 'Vyřešeno!';

  @override
  String get gameOver => 'Konec hry';

  @override
  String clearedSub(String difficulty) {
    return 'Zvládli jste obtížnost $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Dosáhli jste $max chyb',
      many: 'Dosáhli jste $max chyb',
      few: 'Dosáhli jste $max chyb',
      one: 'Dosáhli jste $max chyby',
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
  String get difficulty => 'Obtížnost';

  @override
  String get home => 'Domů';

  @override
  String get all => 'Vše';

  @override
  String get bestRecords => 'Nejlepší časy';

  @override
  String get bestRecordsSub => 'Nejrychlejší čas pro každou obtížnost';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nedávné hry ($count)',
      many: 'Nedávné hry ($count)',
      few: 'Nedávné hry ($count)',
      one: 'Nedávná hra ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Zatím žádné záznamy';

  @override
  String get noRecordsSub => 'Vyřešte hádanku a uvidíte ji zde';

  @override
  String get clearTime => 'Čas řešení';

  @override
  String get checkOff => 'Bez kontroly';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chyb',
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
  String get clearAll => 'Smazat vše';

  @override
  String get clearAllTitle => 'Smazat všechny záznamy?';

  @override
  String get clearAllBody => 'Smazané záznamy nelze obnovit.';

  @override
  String get delete => 'Smazat';

  @override
  String get instantCheckDefault => 'Okamžitá kontrola ve výchozím stavu';

  @override
  String get instantCheckDesc => 'Chybné zadání zobrazit hned';

  @override
  String get privacyOptions => 'Možnosti ochrany soukromí';

  @override
  String get privacyOptionsDesc =>
      'Zkontrolujte nebo změňte nastavení souhlasu s reklamami';

  @override
  String get privacyPolicy => 'Zásady ochrany osobních údajů';

  @override
  String get openLinkFailed => 'Odkaz nelze otevřít';

  @override
  String get appVersion => 'Verze aplikace';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Lehká';

  @override
  String get difficultyNormal => 'Střední';

  @override
  String get difficultyHard => 'Těžká';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyHell => 'Peklo';
}
