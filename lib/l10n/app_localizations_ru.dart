// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Судоку';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Спокойная сосредоточенность, ежедневный отдых для ума';

  @override
  String get newGame => 'Новая игра';

  @override
  String get records => 'Рекорды';

  @override
  String get settings => 'Настройки';

  @override
  String get continueTitle => 'Незавершённая игра';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'Готово $progressString · прошло $time';
  }

  @override
  String get overwriteTitle => 'Начать новую игру?';

  @override
  String get overwriteBody => 'Незавершённая игра будет потеряна.';

  @override
  String get saveIncompatible =>
      'Сохранённую игру из старой версии не удалось продолжить, поэтому она удалена.';

  @override
  String get cancel => 'Отмена';

  @override
  String get removeAds => 'Убрать рекламу';

  @override
  String removeAdsWithPrice(String price) {
    return 'Убрать рекламу $price';
  }

  @override
  String get removeAdsDesc => 'Одна покупка — навсегда без рекламы';

  @override
  String get removeAdsLongDesc =>
      'Уберите всю рекламу навсегда одной покупкой и полностью сосредоточьтесь на головоломке.';

  @override
  String get adsRemoved => 'Реклама убрана';

  @override
  String get purchasePending => 'Обработка';

  @override
  String get storeUnavailable => 'Не удаётся подключиться к магазину';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get restoreRequested => 'Проверяем историю покупок';

  @override
  String get purchaseFailed =>
      'Не удалось завершить оплату. Повторите попытку позже';

  @override
  String get restoreFailed =>
      'Не удалось восстановить покупки. Повторите попытку позже';

  @override
  String get restoreNone => 'Нет покупок для восстановления';

  @override
  String get resultRemoveAdsLine => 'Хотите играть без рекламы?';

  @override
  String get chooseDifficulty => 'Выберите сложность';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Игра окончена после $max ошибки · Отмена не уменьшает число ошибок',
      many:
          'Игра окончена после $max ошибок · Отмена не уменьшает число ошибок',
      few: 'Игра окончена после $max ошибок · Отмена не уменьшает число ошибок',
      one: 'Игра окончена после $max ошибки · Отмена не уменьшает число ошибок',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Скоро начнём';

  @override
  String get preparingSub => 'Создаём новую головоломку…';

  @override
  String get puzzleFailed =>
      'Не удалось создать головоломку. Попробуйте ещё раз';

  @override
  String get back => 'Назад';

  @override
  String get more => 'Ещё';

  @override
  String get restartSame => 'Заново';

  @override
  String get restartConfirmTitle => 'Начать эту головоломку заново?';

  @override
  String get restartConfirmBody =>
      'Введённые цифры, время и ошибки будут сброшены.';

  @override
  String get instantCheck => 'Мгновенная проверка';

  @override
  String mistakes(int count, int max) {
    return 'Ошибки $count/$max';
  }

  @override
  String get undo => 'Отменить';

  @override
  String get erase => 'Стереть';

  @override
  String get memo => 'Заметки';

  @override
  String get memoOn => 'Заметки ВКЛ';

  @override
  String get mistakeKept => 'Отмена хода не уменьшает число ошибок';

  @override
  String cellEmpty(int row, int column) {
    return 'Строка $row, столбец $column, пусто';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Строка $row, столбец $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, осталось $count';
  }

  @override
  String get cleared => 'Решено!';

  @override
  String get gameOver => 'Игра окончена';

  @override
  String clearedSub(String difficulty) {
    return 'Вы прошли уровень «$difficulty»';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Вы допустили $max ошибки',
      many: 'Вы допустили $max ошибок',
      few: 'Вы допустили $max ошибки',
      one: 'Вы допустили $max ошибку',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Новый рекорд';

  @override
  String get time => 'Время';

  @override
  String get mistakeCount => 'Ошибки';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count раза',
      many: '$count раз',
      few: '$count раза',
      one: '$count раз',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Сложность';

  @override
  String get home => 'Главная';

  @override
  String get all => 'Все';

  @override
  String get bestRecords => 'Лучшее время';

  @override
  String get bestRecordsSub => 'Самое быстрое прохождение для каждой сложности';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Последние игры ($count)',
      many: 'Последние игры ($count)',
      few: 'Последние игры ($count)',
      one: 'Последние игры ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Пока нет рекордов';

  @override
  String get noRecordsSub => 'Решите головоломку, и она появится здесь';

  @override
  String get clearTime => 'Время решения';

  @override
  String get checkOff => 'Без проверки';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ошибки',
      many: '$count ошибок',
      few: '$count ошибки',
      one: '$count ошибка',
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
  String get clearAll => 'Удалить все';

  @override
  String get clearAllTitle => 'Удалить все рекорды?';

  @override
  String get clearAllBody => 'Удалённые рекорды нельзя восстановить.';

  @override
  String get delete => 'Удалить';

  @override
  String get instantCheckDefault => 'Мгновенная проверка по умолчанию';

  @override
  String get instantCheckDesc => 'Сразу показывать неверные цифры';

  @override
  String get privacyOptions => 'Параметры конфиденциальности';

  @override
  String get privacyOptionsDesc =>
      'Просмотр и изменение настроек согласия на рекламу';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get openLinkFailed => 'Не удалось открыть ссылку';

  @override
  String get appVersion => 'Версия приложения';

  @override
  String get footer => 'Судоку (Sudoku JANG)';

  @override
  String get difficultyEasy => 'Лёгкий';

  @override
  String get difficultyNormal => 'Средний';

  @override
  String get difficultyHard => 'Сложный';

  @override
  String get difficultyExpert => 'Эксперт';

  @override
  String get difficultyHell => 'Ад';
}
