// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Rolig fokus, en daglig pause for hodet';

  @override
  String get newGame => 'Nytt spill';

  @override
  String get records => 'Historikk';

  @override
  String get settings => 'Innstillinger';

  @override
  String get continueTitle => 'Pågående spill';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString fullført · $time brukt';
  }

  @override
  String get overwriteTitle => 'Starte et nytt spill?';

  @override
  String get overwriteBody => 'Det pågående spillet går tapt.';

  @override
  String get saveIncompatible =>
      'Et lagret spill fra en eldre versjon kunne ikke gjenopptas og ble slettet.';

  @override
  String get cancel => 'Avbryt';

  @override
  String get removeAds => 'Fjern reklame';

  @override
  String removeAdsWithPrice(String price) {
    return 'Fjern reklame $price';
  }

  @override
  String get removeAdsDesc => 'Ett kjøp, reklamefritt for alltid';

  @override
  String get removeAdsLongDesc =>
      'Fjern all reklame for godt med ett enkelt kjøp, og fokuser helt på oppgaven.';

  @override
  String get adsRemoved => 'Reklame fjernet';

  @override
  String get purchasePending => 'Behandles';

  @override
  String get storeUnavailable => 'Kan ikke koble til butikken';

  @override
  String get restorePurchases => 'Gjenopprett kjøp';

  @override
  String get restoreRequested => 'Sjekker kjøpshistorikken din';

  @override
  String get purchaseFailed =>
      'Betalingen kunne ikke fullføres. Prøv igjen senere';

  @override
  String get restoreFailed =>
      'Kjøp kunne ikke gjenopprettes. Prøv igjen senere';

  @override
  String get restoreNone => 'Ingen kjøp å gjenopprette';

  @override
  String get resultRemoveAdsLine => 'Vil du spille uten reklame?';

  @override
  String get chooseDifficulty => 'Velg vanskelighetsgrad';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Spillet er over etter $max feil · Angre reduserer ikke feil',
      one: 'Spillet er over etter $max feil · Angre reduserer ikke feil',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Vi starter straks';

  @override
  String get preparingSub => 'Lager en ny oppgave…';

  @override
  String get puzzleFailed => 'Kunne ikke lage oppgaven. Prøv igjen';

  @override
  String get back => 'Tilbake';

  @override
  String get more => 'Mer';

  @override
  String get restartSame => 'Start på nytt';

  @override
  String get restartConfirmTitle => 'Starte denne oppgaven på nytt?';

  @override
  String get restartConfirmBody => 'Tall, tid og feil blir nullstilt.';

  @override
  String get instantCheck => 'Direktesjekk';

  @override
  String mistakes(int count, int max) {
    return 'Feil $count/$max';
  }

  @override
  String get undo => 'Angre';

  @override
  String get erase => 'Visk ut';

  @override
  String get memo => 'Notater';

  @override
  String get memoOn => 'Notater PÅ';

  @override
  String get mistakeKept => 'Angre reduserer ikke antall feil';

  @override
  String cellEmpty(int row, int column) {
    return 'Rad $row, kolonne $column, tom';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Rad $row, kolonne $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, $count igjen';
  }

  @override
  String get cleared => 'Løst!';

  @override
  String get gameOver => 'Spillet er over';

  @override
  String clearedSub(String difficulty) {
    return 'Du klarte nivået $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Du nådde $max feil',
      one: 'Du nådde $max feil',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Ny rekord';

  @override
  String get time => 'Tid';

  @override
  String get mistakeCount => 'Feil';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ganger',
      one: '$count gang',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Nivå';

  @override
  String get home => 'Hjem';

  @override
  String get all => 'Alle';

  @override
  String get bestRecords => 'Beste tider';

  @override
  String get bestRecordsSub => 'Raskeste tid per vanskelighetsgrad';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Siste spill ($count)',
      one: 'Siste spill ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Ingen spill ennå';

  @override
  String get noRecordsSub => 'Løs en oppgave for å se den her';

  @override
  String get clearTime => 'Løsningstid';

  @override
  String get checkOff => 'Uten sjekk';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count feil',
      one: '$count feil',
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
  String get clearAll => 'Slett alt';

  @override
  String get clearAllTitle => 'Slette all historikk?';

  @override
  String get clearAllBody => 'Slettede spill kan ikke gjenopprettes.';

  @override
  String get delete => 'Slett';

  @override
  String get instantCheckDefault => 'Direktesjekk som standard';

  @override
  String get instantCheckDesc => 'Vis feil tall med en gang de skrives inn';

  @override
  String get soundEffects => 'Lydeffekter';

  @override
  String get soundEffectsDesc => 'Lyder for inntasting, feil og fullføring';

  @override
  String get privacyOptions => 'Personvernvalg';

  @override
  String get privacyOptionsDesc =>
      'Se gjennom eller endre innstillingene for samtykke til annonser';

  @override
  String get privacyPolicy => 'Personvernerklæring';

  @override
  String get openLinkFailed => 'Kunne ikke åpne lenken';

  @override
  String get appVersion => 'Appversjon';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Lett';

  @override
  String get difficultyNormal => 'Middels';

  @override
  String get difficultyHard => 'Vanskelig';

  @override
  String get difficultyExpert => 'Ekspert';

  @override
  String get difficultyHell => 'Helvete';

  @override
  String get hint => 'Hint';

  @override
  String get hintUse => 'Bruk hint';

  @override
  String get hintRankingWarn =>
      'Bruker du et hint, kommer ikke spillet med på denne ukens rangering';

  @override
  String get rewardHintTitle => 'Se en reklame for et hint';

  @override
  String get rewardHintBody =>
      'Se en kort reklame til slutt for å få 1 hint. Gratis hint fylles opp til 3 igjen i morgen.';

  @override
  String get rewardContinueBody =>
      'Se en kort reklame til slutt for å nullstille feilene og spille videre.';

  @override
  String get watchAd => 'Se reklame';

  @override
  String get adLoading => 'Laster inn reklame…';

  @override
  String get adUnavailable => 'Kan ikke laste inn reklame nå';

  @override
  String get adNotCompleted => 'Se reklamen til slutt for å få belønningen';

  @override
  String get continueAfterFail => 'Spill videre';

  @override
  String get continueWithAd => 'Se reklame og spill videre';

  @override
  String get weeklyTitle => 'Ukens utfordring';

  @override
  String weeklyWeekLabel(int week) {
    return 'Uke $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Til $date';
  }

  @override
  String get weeklyRule => 'Bare løsninger uten hint kommer med på rangeringen';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Løst $done/$total';
  }

  @override
  String get weeklyChallenge => 'Spill';

  @override
  String get weeklyRetry => 'Spill igjen';

  @override
  String get weeklyNotPlayed => 'Ikke spilt ennå';

  @override
  String get weeklyInProgress => 'Pågår';

  @override
  String get weeklyNoLeader => 'Ingen på førsteplass ennå';

  @override
  String get weeklyLoadFailed => 'Kunne ikke laste inn rangeringen';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get weeklyYouAreFirst => 'Du er nr. 1!';

  @override
  String weeklyMyBest(String time) {
    return 'Min beste tid denne uken $time';
  }

  @override
  String get weeklySending => 'Sender — fullføres når du er på nett';

  @override
  String get weeklyRank1 => 'Nr. 1 denne uken!';

  @override
  String get weeklyHintExcluded => 'Hint brukt — ikke rangert denne uken';

  @override
  String get weeklyLastWeek => 'Forrige ukes oppgave — ikke registrert';

  @override
  String get rankingExcluded => 'Ikke rangert';

  @override
  String get anonymous => 'Anonym';

  @override
  String get weeklyReport => 'Rapporter et kallenavn';

  @override
  String get nickname => 'Kallenavn';

  @override
  String get nicknameSet => 'Velg kallenavn';

  @override
  String get nicknameChange => 'Endre';

  @override
  String get nicknameHelper => 'Vises på resultatlisten';

  @override
  String get nicknameTooShort => 'Bruk minst 2 tegn';

  @override
  String get nicknameInvalid => 'Bare bokstaver, tall, mellomrom og _';

  @override
  String get nicknameBanned => 'Dette kallenavnet er ikke tillatt';

  @override
  String get save => 'Lagre';
}
