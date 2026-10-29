// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Rolig fordybelse, en daglig pause for hovedet';

  @override
  String get newGame => 'Nyt spil';

  @override
  String get records => 'Historik';

  @override
  String get settings => 'Indstillinger';

  @override
  String get continueTitle => 'Igangværende spil';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString udfyldt · $time gået';
  }

  @override
  String get overwriteTitle => 'Starte et nyt spil?';

  @override
  String get overwriteBody => 'Det igangværende spil går tabt.';

  @override
  String get saveIncompatible =>
      'Et gemt spil fra en ældre version kunne ikke genoptages og er blevet slettet.';

  @override
  String get cancel => 'Annuller';

  @override
  String get removeAds => 'Fjern reklamer';

  @override
  String removeAdsWithPrice(String price) {
    return 'Fjern reklamer $price';
  }

  @override
  String get removeAdsDesc => 'Ét køb, uden reklamer for altid';

  @override
  String get removeAdsLongDesc =>
      'Fjern alle reklamer permanent med ét køb, og fokuser helt på opgaven.';

  @override
  String get adsRemoved => 'Reklamer fjernet';

  @override
  String get purchasePending => 'Behandler';

  @override
  String get storeUnavailable => 'Kan ikke oprette forbindelse til butikken';

  @override
  String get restorePurchases => 'Gendan køb';

  @override
  String get restoreRequested => 'Tjekker din købshistorik';

  @override
  String get purchaseFailed =>
      'Betalingen kunne ikke gennemføres. Prøv igen senere';

  @override
  String get restoreFailed => 'Køb kunne ikke gendannes. Prøv igen senere';

  @override
  String get restoreNone => 'Ingen køb at gendanne';

  @override
  String get resultRemoveAdsLine => 'Vil du spille uden reklamer?';

  @override
  String get chooseDifficulty => 'Vælg sværhedsgrad';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Spillet slutter efter $max fejl · Fortryd mindsker ikke fejl',
      one: 'Spillet slutter efter $max fejl · Fortryd mindsker ikke fejl',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Vi starter om lidt';

  @override
  String get preparingSub => 'Laver en ny opgave…';

  @override
  String get puzzleFailed => 'Opgaven kunne ikke oprettes. Prøv igen';

  @override
  String get back => 'Tilbage';

  @override
  String get more => 'Mere';

  @override
  String get restartSame => 'Start forfra';

  @override
  String get restartConfirmTitle => 'Starte denne opgave forfra?';

  @override
  String get restartConfirmBody => 'Indtastninger, tid og fejl nulstilles.';

  @override
  String get instantCheck => 'Straks-tjek';

  @override
  String mistakes(int count, int max) {
    return 'Fejl $count/$max';
  }

  @override
  String get undo => 'Fortryd';

  @override
  String get erase => 'Slet';

  @override
  String get memo => 'Noter';

  @override
  String get memoOn => 'Noter TIL';

  @override
  String get mistakeKept => 'Fortryd mindsker ikke antallet af fejl';

  @override
  String cellEmpty(int row, int column) {
    return 'Række $row, kolonne $column, tom';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Række $row, kolonne $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, $count tilbage';
  }

  @override
  String get cleared => 'Løst!';

  @override
  String get gameOver => 'Spillet er slut';

  @override
  String clearedSub(String difficulty) {
    return 'Du klarede sværhedsgraden $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Du nåede $max fejl',
      one: 'Du nåede $max fejl',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Ny rekord';

  @override
  String get time => 'Tid';

  @override
  String get mistakeCount => 'Fejl';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gange',
      one: '$count gang',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Niveau';

  @override
  String get home => 'Hjem';

  @override
  String get all => 'Alle';

  @override
  String get bestRecords => 'Bedste tider';

  @override
  String get bestRecordsSub => 'Hurtigste tid for hver sværhedsgrad';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seneste spil ($count)',
      one: 'Seneste spil ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Ingen spil endnu';

  @override
  String get noRecordsSub => 'Løs en opgave for at se den her';

  @override
  String get clearTime => 'Løsningstid';

  @override
  String get checkOff => 'Uden tjek';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fejl',
      one: '$count fejl',
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
  String get clearAll => 'Slet alle';

  @override
  String get clearAllTitle => 'Slette al historik?';

  @override
  String get clearAllBody => 'Slettede spil kan ikke gendannes.';

  @override
  String get delete => 'Slet';

  @override
  String get instantCheckDefault => 'Straks-tjek som standard';

  @override
  String get instantCheckDesc => 'Vis forkerte tal, så snart de indtastes';

  @override
  String get soundEffects => 'Lydeffekter';

  @override
  String get soundEffectsDesc => 'Lyde ved indtastning, fejl og fuldførelse';

  @override
  String get privacyOptions => 'Privatlivsindstillinger';

  @override
  String get privacyOptionsDesc =>
      'Se eller skift dine indstillinger for samtykke til annoncer';

  @override
  String get privacyPolicy => 'Privatlivspolitik';

  @override
  String get openLinkFailed => 'Linket kunne ikke åbnes';

  @override
  String get appVersion => 'Appversion';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Let';

  @override
  String get difficultyNormal => 'Middel';

  @override
  String get difficultyHard => 'Svær';

  @override
  String get difficultyExpert => 'Ekspert';

  @override
  String get difficultyHell => 'Helvede';

  @override
  String get hint => 'Hint';

  @override
  String get hintUse => 'Brug hint';

  @override
  String get hintRankingWarn =>
      'Hvis du bruger et hint, tæller spillet ikke med på denne uges rangliste';

  @override
  String get rewardHintTitle => 'Se en reklame for et hint';

  @override
  String get rewardHintBody =>
      'Se en kort reklame til ende, og få 1 hint. Gratis hints fyldes op til 3 igen i morgen.';

  @override
  String get rewardContinueBody =>
      'Se en kort reklame til ende for at nulstille fejl og spille videre.';

  @override
  String get watchAd => 'Se reklame';

  @override
  String get adLoading => 'Indlæser reklame…';

  @override
  String get adUnavailable => 'Kan ikke indlæse en reklame lige nu';

  @override
  String get adNotCompleted => 'Se reklamen til ende for at få belønningen';

  @override
  String get continueAfterFail => 'Spil videre';

  @override
  String get continueWithAd => 'Se reklame og spil videre';

  @override
  String get weeklyTitle => 'Ugens udfordring';

  @override
  String weeklyWeekLabel(int week) {
    return 'Uge $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Indtil $date';
  }

  @override
  String get weeklyRule => 'Kun løsninger uden hints kommer på ranglisten';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Løst $done/$total';
  }

  @override
  String get weeklyChallenge => 'Spil';

  @override
  String get weeklyRetry => 'Spil igen';

  @override
  String get weeklyNotPlayed => 'Ikke spillet endnu';

  @override
  String get weeklyInProgress => 'I gang';

  @override
  String get weeklyNoLeader => 'Ingen på førstepladsen endnu';

  @override
  String get weeklyLoadFailed => 'Kunne ikke indlæse ranglisten';

  @override
  String get retry => 'Prøv igen';

  @override
  String get weeklyYouAreFirst => 'Du er nr. 1!';

  @override
  String weeklyMyBest(String time) {
    return 'Min bedste tid i denne uge $time';
  }

  @override
  String get weeklySending => 'Sender — fuldføres, når du er online';

  @override
  String get weeklyRank1 => 'Nr. 1 i denne uge!';

  @override
  String get weeklyHintExcluded =>
      'Hint brugt — ikke på ranglisten i denne uge';

  @override
  String get weeklyLastWeek => 'Sidste uges opgave — ikke registreret';

  @override
  String get rankingExcluded => 'Ikke rangeret';

  @override
  String get anonymous => 'Anonym';

  @override
  String get weeklyReport => 'Anmeld et kaldenavn';

  @override
  String get nickname => 'Kaldenavn';

  @override
  String get nicknameSet => 'Vælg kaldenavn';

  @override
  String get nicknameChange => 'Skift';

  @override
  String get nicknameHelper => 'Vises på ranglisten';

  @override
  String get nicknameTooShort => 'Brug mindst 2 tegn';

  @override
  String get nicknameInvalid => 'Kun bogstaver, tal, mellemrum og _';

  @override
  String get nicknameBanned => 'Dette kaldenavn er ikke tilladt';

  @override
  String get save => 'Gem';
}
