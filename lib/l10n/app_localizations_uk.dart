// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Судоку';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline =>
      'Спокійна зосередженість, щоденний відпочинок для розуму';

  @override
  String get newGame => 'Нова гра';

  @override
  String get records => 'Рекорди';

  @override
  String get settings => 'Налаштування';

  @override
  String get continueTitle => 'Незавершена гра';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'Готово $progressString · минуло $time';
  }

  @override
  String get overwriteTitle => 'Почати нову гру?';

  @override
  String get overwriteBody => 'Незавершену гру буде втрачено.';

  @override
  String get saveIncompatible =>
      'Збережену гру зі старої версії не вдалося продовжити, тому її видалено.';

  @override
  String get cancel => 'Скасувати';

  @override
  String get removeAds => 'Прибрати рекламу';

  @override
  String removeAdsWithPrice(String price) {
    return 'Прибрати рекламу $price';
  }

  @override
  String get removeAdsDesc => 'Одна покупка — назавжди без реклами';

  @override
  String get removeAdsLongDesc =>
      'Приберіть усю рекламу назавжди однією покупкою та повністю зосередьтеся на головоломці.';

  @override
  String get adsRemoved => 'Рекламу прибрано';

  @override
  String get purchasePending => 'Обробка';

  @override
  String get storeUnavailable => 'Не вдається під’єднатися до магазину';

  @override
  String get restorePurchases => 'Відновити покупки';

  @override
  String get restoreRequested => 'Перевіряємо історію покупок';

  @override
  String get purchaseFailed => 'Не вдалося завершити оплату. Спробуйте пізніше';

  @override
  String get restoreFailed => 'Не вдалося відновити покупки. Спробуйте пізніше';

  @override
  String get restoreNone => 'Немає покупок для відновлення';

  @override
  String get resultRemoveAdsLine => 'Хочете грати без реклами?';

  @override
  String get chooseDifficulty => 'Виберіть складність';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Гра закінчується після $max помилки · Скасування не зменшує кількість помилок',
      many:
          'Гра закінчується після $max помилок · Скасування не зменшує кількість помилок',
      few:
          'Гра закінчується після $max помилок · Скасування не зменшує кількість помилок',
      one:
          'Гра закінчується після $max помилки · Скасування не зменшує кількість помилок',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Скоро почнемо';

  @override
  String get preparingSub => 'Створюємо нову головоломку…';

  @override
  String get puzzleFailed =>
      'Не вдалося створити головоломку. Спробуйте ще раз';

  @override
  String get back => 'Назад';

  @override
  String get more => 'Більше';

  @override
  String get restartSame => 'Заново';

  @override
  String get restartConfirmTitle => 'Почати цю головоломку заново?';

  @override
  String get restartConfirmBody => 'Введені цифри, час і помилки буде скинуто.';

  @override
  String get instantCheck => 'Миттєва перевірка';

  @override
  String mistakes(int count, int max) {
    return 'Помилки $count/$max';
  }

  @override
  String get undo => 'Скасувати';

  @override
  String get erase => 'Стерти';

  @override
  String get memo => 'Нотатки';

  @override
  String get memoOn => 'Нотатки УВІМК';

  @override
  String get mistakeKept => 'Скасування ходу не зменшує кількість помилок';

  @override
  String cellEmpty(int row, int column) {
    return 'Рядок $row, стовпець $column, порожньо';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Рядок $row, стовпець $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, залишилося $count';
  }

  @override
  String get cleared => 'Розв’язано!';

  @override
  String get gameOver => 'Гру закінчено';

  @override
  String clearedSub(String difficulty) {
    return 'Ви пройшли рівень «$difficulty»';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Ви припустилися $max помилки',
      many: 'Ви припустилися $max помилок',
      few: 'Ви припустилися $max помилок',
      one: 'Ви припустилися $max помилки',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Новий рекорд';

  @override
  String get time => 'Час';

  @override
  String get mistakeCount => 'Помилки';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count раза',
      many: '$count разів',
      few: '$count рази',
      one: '$count раз',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Складність';

  @override
  String get home => 'Головна';

  @override
  String get all => 'Усі';

  @override
  String get bestRecords => 'Найкращий час';

  @override
  String get bestRecordsSub => 'Найшвидше проходження для кожної складності';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Останні ігри ($count)',
      many: 'Останні ігри ($count)',
      few: 'Останні ігри ($count)',
      one: 'Останні ігри ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Поки немає рекордів';

  @override
  String get noRecordsSub => 'Розв’яжіть головоломку, і вона з’явиться тут';

  @override
  String get clearTime => 'Час розв’язання';

  @override
  String get checkOff => 'Без перевірки';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count помилки',
      many: '$count помилок',
      few: '$count помилки',
      one: '$count помилка',
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
  String get clearAll => 'Видалити все';

  @override
  String get clearAllTitle => 'Видалити всі рекорди?';

  @override
  String get clearAllBody => 'Видалені рекорди не можна відновити.';

  @override
  String get delete => 'Видалити';

  @override
  String get instantCheckDefault => 'Миттєва перевірка за замовчуванням';

  @override
  String get instantCheckDesc => 'Одразу показувати неправильні цифри';

  @override
  String get soundEffects => 'Звукові ефекти';

  @override
  String get soundEffectsDesc => 'Звуки введення, помилки та завершення';

  @override
  String get privacyOptions => 'Параметри конфіденційності';

  @override
  String get privacyOptionsDesc =>
      'Перегляньте або змініть налаштування згоди на рекламу';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get openLinkFailed => 'Не вдалося відкрити посилання';

  @override
  String get appVersion => 'Версія застосунку';

  @override
  String get footer => 'Судоку (Sudoku JANG)';

  @override
  String get difficultyEasy => 'Легкий';

  @override
  String get difficultyNormal => 'Середній';

  @override
  String get difficultyHard => 'Складний';

  @override
  String get difficultyExpert => 'Експерт';

  @override
  String get difficultyHell => 'Пекло';

  @override
  String get hint => 'Підказка';

  @override
  String get hintUse => 'Взяти підказку';

  @override
  String get hintRankingWarn =>
      'З підказкою ця гра не потрапить до рейтингу цього тижня';

  @override
  String get rewardHintTitle => 'Підказка за рекламу';

  @override
  String get rewardHintBody =>
      'Перегляньте коротку рекламу до кінця й отримайте 1 підказку. Завтра безкоштовних підказок знову буде 3.';

  @override
  String get rewardContinueBody =>
      'Перегляньте коротку рекламу до кінця, щоб обнулити помилки й продовжити гру.';

  @override
  String get watchAd => 'Дивитися рекламу';

  @override
  String get adLoading => 'Завантаження реклами…';

  @override
  String get adUnavailable => 'Зараз не вдається завантажити рекламу';

  @override
  String get adNotCompleted =>
      'Перегляньте рекламу до кінця, щоб отримати нагороду';

  @override
  String get continueAfterFail => 'Продовжити';

  @override
  String get continueWithAd => 'Продовжити за рекламу';

  @override
  String get weeklyTitle => 'Виклик тижня';

  @override
  String weeklyWeekLabel(int week) {
    return 'Тиждень $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'До $date';
  }

  @override
  String get weeklyRule =>
      'До рейтингу потрапляють лише розв’язки без підказок';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Розв’язано $done/$total';
  }

  @override
  String get weeklyChallenge => 'Грати';

  @override
  String get weeklyRetry => 'Ще раз';

  @override
  String get weeklyNotPlayed => 'Ще не зіграно';

  @override
  String get weeklyInProgress => 'Триває';

  @override
  String get weeklyNoLeader => 'Поки немає лідера';

  @override
  String get weeklyLoadFailed => 'Не вдалося завантажити рейтинг';

  @override
  String get retry => 'Повторити';

  @override
  String get weeklyYouAreFirst => 'Ви на 1-му місці!';

  @override
  String weeklyMyBest(String time) {
    return 'Мій найкращий час цього тижня $time';
  }

  @override
  String get weeklySending =>
      'Надсилання — завершиться, щойно з’явиться мережа';

  @override
  String get weeklyRank1 => '1-ше місце цього тижня!';

  @override
  String get weeklyHintExcluded =>
      'Використано підказку — поза рейтингом цього тижня';

  @override
  String get weeklyLastWeek => 'Головоломка минулого тижня — не зараховано';

  @override
  String get rankingExcluded => 'Поза рейтингом';

  @override
  String get anonymous => 'Анонім';

  @override
  String get weeklyReport => 'Поскаржитися на нікнейм';

  @override
  String get nickname => 'Нікнейм';

  @override
  String get nicknameSet => 'Задати нікнейм';

  @override
  String get nicknameChange => 'Змінити';

  @override
  String get nicknameHelper => 'Показується в рейтингу';

  @override
  String get nicknameTooShort => 'Щонайменше 2 символи';

  @override
  String get nicknameInvalid => 'Лише літери, цифри, пробіли та _';

  @override
  String get nicknameBanned => 'Цей нікнейм заборонено';

  @override
  String get save => 'Зберегти';
}
