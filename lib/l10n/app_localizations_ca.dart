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
}
