// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline =>
      'Concentración serena, un descanso diario para tu mente';

  @override
  String get newGame => 'Nueva partida';

  @override
  String get records => 'Récords';

  @override
  String get settings => 'Ajustes';

  @override
  String get continueTitle => 'Partida en curso';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString completado · $time transcurrido';
  }

  @override
  String get overwriteTitle => '¿Empezar una partida nueva?';

  @override
  String get overwriteBody => 'Se perderá la partida en curso.';

  @override
  String get saveIncompatible =>
      'La partida guardada de una versión anterior no se podía continuar y se eliminó.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String removeAdsWithPrice(String price) {
    return 'Quitar anuncios $price';
  }

  @override
  String get removeAdsDesc => 'Una sola compra, sin anuncios para siempre';

  @override
  String get removeAdsLongDesc =>
      'Elimina para siempre todos los anuncios con una sola compra y concéntrate por completo en el puzle.';

  @override
  String get adsRemoved => 'Anuncios quitados';

  @override
  String get purchasePending => 'Procesando';

  @override
  String get storeUnavailable => 'No se puede conectar con la tienda';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get restoreRequested => 'Comprobando tus compras';

  @override
  String get purchaseFailed =>
      'No se pudo completar el pago. Inténtalo de nuevo más tarde';

  @override
  String get restoreFailed =>
      'No se pudieron restaurar las compras. Inténtalo de nuevo más tarde';

  @override
  String get restoreNone => 'No hay compras para restaurar';

  @override
  String get resultRemoveAdsLine => '¿Quieres jugar sin anuncios?';

  @override
  String get chooseDifficulty => 'Elegir dificultad';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Fin de la partida con $max errores · Deshacer no reduce los errores',
      one: 'Fin de la partida con $max error · Deshacer no reduce los errores',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Empezamos en un momento';

  @override
  String get preparingSub => 'Generando un puzle nuevo…';

  @override
  String get puzzleFailed => 'No se pudo crear el puzle. Inténtalo de nuevo';

  @override
  String get back => 'Atrás';

  @override
  String get more => 'Más';

  @override
  String get restartSame => 'Reiniciar puzle';

  @override
  String get restartConfirmTitle => '¿Reiniciar este puzle desde el principio?';

  @override
  String get restartConfirmBody =>
      'Se restablecerán los números, el tiempo y los errores.';

  @override
  String get instantCheck => 'Comprobación inmediata';

  @override
  String mistakes(int count, int max) {
    return 'Errores $count/$max';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get erase => 'Borrar';

  @override
  String get memo => 'Notas';

  @override
  String get memoOn => 'Notas activas';

  @override
  String get mistakeKept => 'Deshacer no reduce el número de errores';

  @override
  String cellEmpty(int row, int column) {
    return 'Fila $row, columna $column, vacía';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Fila $row, columna $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, quedan $count';
  }

  @override
  String get cleared => '¡Resuelto!';

  @override
  String get gameOver => 'Fin de la partida';

  @override
  String clearedSub(String difficulty) {
    return 'Completaste el nivel $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Llegaste a $max errores',
      one: 'Llegaste a $max error',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Nuevo récord';

  @override
  String get time => 'Tiempo';

  @override
  String get mistakeCount => 'Errores';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veces',
      one: '$count vez',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Dificultad';

  @override
  String get home => 'Inicio';

  @override
  String get all => 'Todos';

  @override
  String get bestRecords => 'Mejores tiempos';

  @override
  String get bestRecordsSub => 'Tiempo más rápido por dificultad';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Récords recientes ($count)',
      one: 'Récord reciente ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Aún no hay récords';

  @override
  String get noRecordsSub => 'Resuelve un puzle para verlo aquí';

  @override
  String get clearTime => 'Tiempo de resolución';

  @override
  String get checkOff => 'Sin comprobación';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errores',
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
  String get clearAll => 'Borrar todo';

  @override
  String get clearAllTitle => '¿Borrar todos los récords?';

  @override
  String get clearAllBody => 'Los récords borrados no se pueden recuperar.';

  @override
  String get delete => 'Borrar';

  @override
  String get instantCheckDefault => 'Comprobación inmediata por defecto';

  @override
  String get instantCheckDesc => 'Marca los errores en cuanto los introduces';

  @override
  String get privacyOptions => 'Opciones de privacidad';

  @override
  String get privacyOptionsDesc =>
      'Consulta o cambia tu configuración de consentimiento de anuncios';

  @override
  String get appVersion => 'Versión de la app';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get difficultyExpert => 'Experto';

  @override
  String get difficultyHell => 'Infierno';
}
