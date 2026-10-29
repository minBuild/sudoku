// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline =>
      'Rauhallista keskittymistä, päivittäinen tauko mielelle';

  @override
  String get newGame => 'Uusi peli';

  @override
  String get records => 'Tulokset';

  @override
  String get settings => 'Asetukset';

  @override
  String get continueTitle => 'Keskeneräinen peli';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString valmis · $time kulunut';
  }

  @override
  String get overwriteTitle => 'Aloitetaanko uusi peli?';

  @override
  String get overwriteBody => 'Keskeneräinen peli menetetään.';

  @override
  String get saveIncompatible =>
      'Vanhemman version tallennettua peliä ei voitu jatkaa, joten se poistettiin.';

  @override
  String get cancel => 'Peruuta';

  @override
  String get removeAds => 'Poista mainokset';

  @override
  String removeAdsWithPrice(String price) {
    return 'Poista mainokset $price';
  }

  @override
  String get removeAdsDesc => 'Yksi osto, ei mainoksia koskaan';

  @override
  String get removeAdsLongDesc =>
      'Poista kaikki mainokset pysyvästi yhdellä ostolla ja keskity täysin pulmaan.';

  @override
  String get adsRemoved => 'Mainokset poistettu';

  @override
  String get purchasePending => 'Käsitellään';

  @override
  String get storeUnavailable => 'Kauppaan ei saada yhteyttä';

  @override
  String get restorePurchases => 'Palauta ostot';

  @override
  String get restoreRequested => 'Tarkistetaan ostohistoriaa';

  @override
  String get purchaseFailed =>
      'Maksua ei voitu suorittaa. Yritä myöhemmin uudelleen';

  @override
  String get restoreFailed =>
      'Ostoja ei voitu palauttaa. Yritä myöhemmin uudelleen';

  @override
  String get restoreNone => 'Ei palautettavia ostoja';

  @override
  String get resultRemoveAdsLine => 'Haluatko pelata ilman mainoksia?';

  @override
  String get chooseDifficulty => 'Valitse vaikeustaso';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Peli päättyy $max virheeseen · Kumoa ei vähennä virheitä',
      one: 'Peli päättyy $max virheeseen · Kumoa ei vähennä virheitä',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Aloitetaan pian';

  @override
  String get preparingSub => 'Luodaan uutta pulmaa…';

  @override
  String get puzzleFailed => 'Pulmaa ei voitu luoda. Yritä uudelleen';

  @override
  String get back => 'Takaisin';

  @override
  String get more => 'Lisää';

  @override
  String get restartSame => 'Aloita alusta';

  @override
  String get restartConfirmTitle => 'Aloitetaanko tämä pulma alusta?';

  @override
  String get restartConfirmBody =>
      'Syötetyt numerot, aika ja virheet nollataan.';

  @override
  String get instantCheck => 'Pikatarkistus';

  @override
  String mistakes(int count, int max) {
    return 'Virheet $count/$max';
  }

  @override
  String get undo => 'Kumoa';

  @override
  String get erase => 'Pyyhi';

  @override
  String get memo => 'Merkinnät';

  @override
  String get memoOn => 'Merkinnät PÄÄLLÄ';

  @override
  String get mistakeKept => 'Kumoaminen ei vähennä virheiden määrää';

  @override
  String cellEmpty(int row, int column) {
    return 'Rivi $row, sarake $column, tyhjä';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Rivi $row, sarake $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, jäljellä $count';
  }

  @override
  String get cleared => 'Ratkaistu!';

  @override
  String get gameOver => 'Peli päättyi';

  @override
  String clearedSub(String difficulty) {
    return 'Läpäisit vaikeustason $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Saavutit $max virhettä',
      one: 'Saavutit $max virheen',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Uusi ennätys';

  @override
  String get time => 'Aika';

  @override
  String get mistakeCount => 'Virheet';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kertaa',
      one: '$count kerta',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Taso';

  @override
  String get home => 'Alkuun';

  @override
  String get all => 'Kaikki';

  @override
  String get bestRecords => 'Parhaat ajat';

  @override
  String get bestRecordsSub => 'Nopein aika vaikeustasoittain';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Viimeisimmät pelit ($count)',
      one: 'Viimeisin peli ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Ei vielä tuloksia';

  @override
  String get noRecordsSub => 'Ratkaise pulma, niin se näkyy täällä';

  @override
  String get clearTime => 'Ratkaisuaika';

  @override
  String get checkOff => 'Ei tark.';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count virhettä',
      one: '$count virhe',
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
  String get clearAll => 'Poista kaikki';

  @override
  String get clearAllTitle => 'Poistetaanko kaikki tulokset?';

  @override
  String get clearAllBody => 'Poistettuja tuloksia ei voi palauttaa.';

  @override
  String get delete => 'Poista';

  @override
  String get instantCheckDefault => 'Pikatarkistus oletuksena';

  @override
  String get instantCheckDesc => 'Näytä väärät numerot heti syötettäessä';

  @override
  String get soundEffects => 'Äänitehosteet';

  @override
  String get soundEffectsDesc => 'Syötön, virheen ja ratkaisun äänet';

  @override
  String get privacyOptions => 'Tietosuoja-asetukset';

  @override
  String get privacyOptionsDesc =>
      'Tarkista tai muuta mainossuostumuksen asetuksia';

  @override
  String get privacyPolicy => 'Tietosuojakäytäntö';

  @override
  String get openLinkFailed => 'Linkkiä ei voitu avata';

  @override
  String get appVersion => 'Sovelluksen versio';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Helppo';

  @override
  String get difficultyNormal => 'Keskitaso';

  @override
  String get difficultyHard => 'Vaikea';

  @override
  String get difficultyExpert => 'Asiantuntija';

  @override
  String get difficultyHell => 'Helvetti';
}
