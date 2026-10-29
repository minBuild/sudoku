// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Concentració serena, una pausa diària per a la ment';

  @override
  String get newGame => 'Partida nova';

  @override
  String get records => 'Historial';

  @override
  String get settings => 'Configuració';

  @override
  String get continueTitle => 'Partida en curs';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString completat · $time transcorregut';
  }

  @override
  String get overwriteTitle => 'Vols començar una partida nova?';

  @override
  String get overwriteBody => 'Es perdrà la partida en curs.';

  @override
  String get saveIncompatible =>
      'No s\'ha pogut reprendre una partida desada d\'una versió anterior i s\'ha eliminat.';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get removeAds => 'Elimina anuncis';

  @override
  String removeAdsWithPrice(String price) {
    return 'Elimina anuncis $price';
  }

  @override
  String get removeAdsDesc => 'Una sola compra, sense anuncis per sempre';

  @override
  String get removeAdsLongDesc =>
      'Elimina tots els anuncis per sempre amb una sola compra i concentra\'t del tot en el trencaclosques.';

  @override
  String get adsRemoved => 'Anuncis eliminats';

  @override
  String get purchasePending => 'Processant';

  @override
  String get storeUnavailable => 'No es pot connectar amb la botiga';

  @override
  String get restorePurchases => 'Restaura les compres';

  @override
  String get restoreRequested => 'S\'està comprovant l\'historial de compres';

  @override
  String get purchaseFailed =>
      'No s\'ha pogut completar el pagament. Torna-ho a provar més tard';

  @override
  String get restoreFailed =>
      'No s\'han pogut restaurar les compres. Torna-ho a provar més tard';

  @override
  String get restoreNone => 'No hi ha compres per restaurar';

  @override
  String get resultRemoveAdsLine => 'Vols jugar sense anuncis?';

  @override
  String get chooseDifficulty => 'Tria la dificultat';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'La partida acaba amb $max errors · Desfer no redueix els errors',
      one: 'La partida acaba amb $max error · Desfer no redueix els errors',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Comencem de seguida';

  @override
  String get preparingSub => 'S\'està generant un trencaclosques nou…';

  @override
  String get puzzleFailed =>
      'No s\'ha pogut crear el trencaclosques. Torna-ho a provar';

  @override
  String get back => 'Enrere';

  @override
  String get more => 'Més';

  @override
  String get restartSame => 'Reinicia';

  @override
  String get restartConfirmTitle =>
      'Vols reiniciar aquest trencaclosques des del principi?';

  @override
  String get restartConfirmBody =>
      'Es restabliran les xifres, el temps i els errors.';

  @override
  String get instantCheck => 'Comprovació immediata';

  @override
  String mistakes(int count, int max) {
    return 'Errors $count/$max';
  }

  @override
  String get undo => 'Desfés';

  @override
  String get erase => 'Esborra';

  @override
  String get memo => 'Notes';

  @override
  String get memoOn => 'Notes ACT.';

  @override
  String get mistakeKept => 'Desfer no redueix el nombre d\'errors';

  @override
  String cellEmpty(int row, int column) {
    return 'Fila $row, columna $column, buida';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Fila $row, columna $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, en queden $count';
  }

  @override
  String get cleared => 'Resolt!';

  @override
  String get gameOver => 'Fi de la partida';

  @override
  String clearedSub(String difficulty) {
    return 'Has superat el nivell $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Has arribat a $max errors',
      one: 'Has arribat a $max error',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Nou rècord';

  @override
  String get time => 'Temps';

  @override
  String get mistakeCount => 'Errors';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vegades',
      one: '$count vegada',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Dificultat';

  @override
  String get home => 'Inici';

  @override
  String get all => 'Tot';

  @override
  String get bestRecords => 'Millors temps';

  @override
  String get bestRecordsSub => 'Temps més ràpid per dificultat';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Partides recents ($count)',
      one: 'Partida recent ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Encara no hi ha partides';

  @override
  String get noRecordsSub => 'Resol un trencaclosques per veure\'l aquí';

  @override
  String get clearTime => 'Temps de resolució';

  @override
  String get checkOff => 'Sense comprov.';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errors',
      one: '$count error',
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
  String get clearAll => 'Esborra-ho tot';

  @override
  String get clearAllTitle => 'Vols esborrar tot l\'historial?';

  @override
  String get clearAllBody => 'Les partides esborrades no es poden recuperar.';

  @override
  String get delete => 'Esborra';

  @override
  String get instantCheckDefault => 'Comprovació immediata per defecte';

  @override
  String get instantCheckDesc =>
      'Mostra les respostes incorrectes en introduir-les';

  @override
  String get soundEffects => 'Efectes de so';

  @override
  String get soundEffectsDesc => 'Sons d\'entrada, d\'error i de finalització';

  @override
  String get privacyOptions => 'Opcions de privadesa';

  @override
  String get privacyOptionsDesc =>
      'Revisa o canvia la configuració del consentiment d\'anuncis';

  @override
  String get privacyPolicy => 'Política de privadesa';

  @override
  String get openLinkFailed => 'No s\'ha pogut obrir l\'enllaç';

  @override
  String get appVersion => 'Versió de l\'app';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Fàcil';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyHell => 'Infern';

  @override
  String get hint => 'Pista';

  @override
  String get hintUse => 'Usa una pista';

  @override
  String get hintRankingWarn =>
      'Si fas servir una pista, aquesta partida no comptarà al rànquing d\'aquesta setmana';

  @override
  String get rewardHintTitle => 'Mira un anunci per obtenir una pista';

  @override
  String get rewardHintBody =>
      'Mira un anunci curt fins al final per obtenir 1 pista. Demà tornaràs a tenir 3 pistes gratuïtes.';

  @override
  String get rewardContinueBody =>
      'Mira un anunci curt fins al final per posar els errors a zero i continuar jugant.';

  @override
  String get watchAd => 'Mira l\'anunci';

  @override
  String get adLoading => 'Carregant l\'anunci…';

  @override
  String get adUnavailable => 'Ara no es pot carregar cap anunci';

  @override
  String get adNotCompleted =>
      'Mira l\'anunci fins al final per obtenir la recompensa';

  @override
  String get continueAfterFail => 'Continua jugant';

  @override
  String get continueWithAd => 'Mira un anunci i continua';

  @override
  String get weeklyTitle => 'Repte setmanal';

  @override
  String weeklyWeekLabel(int week) {
    return 'Setmana $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Fins a $date';
  }

  @override
  String get weeklyRule => 'Només compten les partides resoltes sense pistes';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Resolts $done/$total';
  }

  @override
  String get weeklyChallenge => 'Juga';

  @override
  String get weeklyRetry => 'Torna a jugar';

  @override
  String get weeklyNotPlayed => 'Encara no hi has jugat';

  @override
  String get weeklyInProgress => 'En curs';

  @override
  String get weeklyNoLeader => 'Encara no hi ha cap líder';

  @override
  String get weeklyLoadFailed => 'No s\'ha pogut carregar el rànquing';

  @override
  String get retry => 'Torna-ho a provar';

  @override
  String get weeklyYouAreFirst => 'Ets el número 1!';

  @override
  String weeklyMyBest(String time) {
    return 'El meu millor temps d\'aquesta setmana $time';
  }

  @override
  String get weeklySending => 'Enviant — s\'acabarà quan tinguis connexió';

  @override
  String get weeklyRank1 => 'Número 1 aquesta setmana!';

  @override
  String get weeklyHintExcluded =>
      'Pista utilitzada — fora del rànquing aquesta setmana';

  @override
  String get weeklyLastWeek =>
      'Trencaclosques de la setmana passada — no s\'ha registrat';

  @override
  String get rankingExcluded => 'Fora del rànquing';

  @override
  String get anonymous => 'Anònim';

  @override
  String get weeklyReport => 'Denuncia un sobrenom';

  @override
  String get nickname => 'Sobrenom';

  @override
  String get nicknameSet => 'Defineix el sobrenom';

  @override
  String get nicknameChange => 'Canvia';

  @override
  String get nicknameHelper => 'Es mostra al rànquing';

  @override
  String get nicknameTooShort => 'Fes servir almenys 2 caràcters';

  @override
  String get nicknameInvalid => 'Només lletres, números, espais i _';

  @override
  String get nicknameBanned => 'Aquest sobrenom no està permès';

  @override
  String get save => 'Desa';
}
