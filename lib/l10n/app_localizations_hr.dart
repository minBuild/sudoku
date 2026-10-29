// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Mirna usredotočenost, svakodnevni odmor za um';

  @override
  String get newGame => 'Nova igra';

  @override
  String get records => 'Rezultati';

  @override
  String get settings => 'Postavke';

  @override
  String get continueTitle => 'Igra u tijeku';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'Riješeno $progressString · proteklo $time';
  }

  @override
  String get overwriteTitle => 'Započeti novu igru?';

  @override
  String get overwriteBody => 'Igra u tijeku bit će izgubljena.';

  @override
  String get saveIncompatible =>
      'Spremljenu igru iz starije verzije nije bilo moguće nastaviti pa je izbrisana.';

  @override
  String get cancel => 'Odustani';

  @override
  String get removeAds => 'Ukloni oglase';

  @override
  String removeAdsWithPrice(String price) {
    return 'Ukloni oglase $price';
  }

  @override
  String get removeAdsDesc => 'Jedna kupnja, zauvijek bez oglasa';

  @override
  String get removeAdsLongDesc =>
      'Jednom kupnjom trajno uklonite sve oglase i potpuno se usredotočite na zagonetku.';

  @override
  String get adsRemoved => 'Oglasi uklonjeni';

  @override
  String get purchasePending => 'Obrada';

  @override
  String get storeUnavailable => 'Nije moguće povezati se s trgovinom';

  @override
  String get restorePurchases => 'Vrati kupnje';

  @override
  String get restoreRequested => 'Provjeravamo povijest kupnji';

  @override
  String get purchaseFailed =>
      'Plaćanje nije dovršeno. Pokušajte ponovno kasnije';

  @override
  String get restoreFailed =>
      'Kupnje nije moguće vratiti. Pokušajte ponovno kasnije';

  @override
  String get restoreNone => 'Nema kupnji za vraćanje';

  @override
  String get resultRemoveAdsLine => 'Želite igrati bez oglasa?';

  @override
  String get chooseDifficulty => 'Odaberite težinu';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Igra završava nakon $max pogrešaka · Poništavanje ne smanjuje pogreške',
      few:
          'Igra završava nakon $max pogreške · Poništavanje ne smanjuje pogreške',
      one:
          'Igra završava nakon $max pogreške · Poništavanje ne smanjuje pogreške',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Uskoro počinjemo';

  @override
  String get preparingSub => 'Stvaramo novu zagonetku…';

  @override
  String get puzzleFailed =>
      'Zagonetku nije moguće stvoriti. Pokušajte ponovno';

  @override
  String get back => 'Natrag';

  @override
  String get more => 'Više';

  @override
  String get restartSame => 'Ispočetka';

  @override
  String get restartConfirmTitle => 'Početi ovu zagonetku ispočetka?';

  @override
  String get restartConfirmBody =>
      'Uneseni brojevi, vrijeme i pogreške bit će poništeni.';

  @override
  String get instantCheck => 'Trenutna provjera';

  @override
  String mistakes(int count, int max) {
    return 'Pogreške $count/$max';
  }

  @override
  String get undo => 'Poništi';

  @override
  String get erase => 'Obriši';

  @override
  String get memo => 'Bilješke';

  @override
  String get memoOn => 'Bilješke UKLJ.';

  @override
  String get mistakeKept => 'Poništavanje ne smanjuje broj pogrešaka';

  @override
  String cellEmpty(int row, int column) {
    return 'Redak $row, stupac $column, prazno';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Redak $row, stupac $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, preostalo $count';
  }

  @override
  String get cleared => 'Riješeno!';

  @override
  String get gameOver => 'Kraj igre';

  @override
  String clearedSub(String difficulty) {
    return 'Svladali ste razinu $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Dosegli ste $max pogrešaka',
      few: 'Dosegli ste $max pogreške',
      one: 'Dosegli ste $max pogrešku',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Novi rekord';

  @override
  String get time => 'Vrijeme';

  @override
  String get mistakeCount => 'Pogreške';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puta',
      few: '$count puta',
      one: '$count put',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Težina';

  @override
  String get home => 'Početna';

  @override
  String get all => 'Sve';

  @override
  String get bestRecords => 'Najbolja vremena';

  @override
  String get bestRecordsSub => 'Najbrže vrijeme po težini';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nedavne igre ($count)',
      few: 'Nedavne igre ($count)',
      one: 'Nedavna igra ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Još nema rezultata';

  @override
  String get noRecordsSub => 'Riješite zagonetku da biste je vidjeli ovdje';

  @override
  String get clearTime => 'Vrijeme rješavanja';

  @override
  String get checkOff => 'Bez provjere';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pogrešaka',
      few: '$count pogreške',
      one: '$count pogreška',
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
  String get clearAll => 'Izbriši sve';

  @override
  String get clearAllTitle => 'Izbrisati sve rezultate?';

  @override
  String get clearAllBody => 'Izbrisane rezultate nije moguće vratiti.';

  @override
  String get delete => 'Izbriši';

  @override
  String get instantCheckDefault =>
      'Trenutna provjera prema zadanim postavkama';

  @override
  String get instantCheckDesc => 'Odmah prikaži pogrešne unose';

  @override
  String get soundEffects => 'Zvučni efekti';

  @override
  String get soundEffectsDesc => 'Zvukovi unosa, pogreške i rješenja';

  @override
  String get privacyOptions => 'Mogućnosti privatnosti';

  @override
  String get privacyOptionsDesc =>
      'Pregledajte ili promijenite postavke pristanka za oglase';

  @override
  String get privacyPolicy => 'Pravila o privatnosti';

  @override
  String get openLinkFailed => 'Poveznicu nije moguće otvoriti';

  @override
  String get appVersion => 'Verzija aplikacije';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Lako';

  @override
  String get difficultyNormal => 'Srednje';

  @override
  String get difficultyHard => 'Teško';

  @override
  String get difficultyExpert => 'Stručnjak';

  @override
  String get difficultyHell => 'Pakao';

  @override
  String get hint => 'Savjet';

  @override
  String get hintUse => 'Iskoristi savjet';

  @override
  String get hintRankingWarn =>
      'Ako iskoristite savjet, ova igra neće ući u ljestvicu ovog tjedna';

  @override
  String get rewardHintTitle => 'Pogledajte oglas za savjet';

  @override
  String get rewardHintBody =>
      'Pogledajte kratki oglas do kraja i dobit ćete 1 savjet. Sutra ćete opet imati 3 besplatna savjeta.';

  @override
  String get rewardContinueBody =>
      'Pogledajte kratki oglas do kraja kako biste poništili pogreške i nastavili igrati.';

  @override
  String get watchAd => 'Pogledaj oglas';

  @override
  String get adLoading => 'Učitavanje oglasa…';

  @override
  String get adUnavailable => 'Oglas se trenutačno ne može učitati';

  @override
  String get adNotCompleted =>
      'Pogledajte oglas do kraja da biste dobili nagradu';

  @override
  String get continueAfterFail => 'Nastavi igrati';

  @override
  String get continueWithAd => 'Pogledaj oglas i nastavi';

  @override
  String get weeklyTitle => 'Tjedni izazov';

  @override
  String weeklyWeekLabel(int week) {
    return '$week. tjedan';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Do $date';
  }

  @override
  String get weeklyRule => 'Na ljestvicu ulaze samo rješenja bez savjeta';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Riješeno $done/$total';
  }

  @override
  String get weeklyChallenge => 'Igraj';

  @override
  String get weeklyRetry => 'Igraj ponovno';

  @override
  String get weeklyNotPlayed => 'Još niste igrali';

  @override
  String get weeklyInProgress => 'U tijeku';

  @override
  String get weeklyNoLeader => 'Još nema prvog mjesta';

  @override
  String get weeklyLoadFailed => 'Ljestvica se nije mogla učitati';

  @override
  String get retry => 'Pokušaj ponovno';

  @override
  String get weeklyYouAreFirst => 'Prvo mjesto!';

  @override
  String weeklyMyBest(String time) {
    return 'Moje najbolje vrijeme ovaj tjedan $time';
  }

  @override
  String get weeklySending => 'Slanje — dovršit će se kad budete na mreži';

  @override
  String get weeklyRank1 => 'Prvo mjesto ovaj tjedan!';

  @override
  String get weeklyHintExcluded =>
      'Iskorišten savjet — izvan ljestvice ovaj tjedan';

  @override
  String get weeklyLastWeek => 'Zagonetka prošlog tjedna — nije zabilježeno';

  @override
  String get rankingExcluded => 'Izvan ljestvice';

  @override
  String get anonymous => 'Anoniman';

  @override
  String get weeklyReport => 'Prijavi nadimak';

  @override
  String get nickname => 'Nadimak';

  @override
  String get nicknameSet => 'Postavi nadimak';

  @override
  String get nicknameChange => 'Promijeni';

  @override
  String get nicknameHelper => 'Prikazuje se na ljestvici';

  @override
  String get nicknameTooShort => 'Unesite najmanje 2 znaka';

  @override
  String get nicknameInvalid => 'Samo slova, brojevi, razmaci i _';

  @override
  String get nicknameBanned => 'Ovaj nadimak nije dopušten';

  @override
  String get save => 'Spremi';
}
