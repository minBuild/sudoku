// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سودوكو';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'تركيز هادئ واستراحة يومية لعقلك';

  @override
  String get newGame => 'لعبة جديدة';

  @override
  String get records => 'السجلات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get continueTitle => 'لعبة قيد التقدم';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'اكتمل $progressString · مضى $time';
  }

  @override
  String get overwriteTitle => 'هل تريد بدء لعبة جديدة؟';

  @override
  String get overwriteBody => 'ستفقد اللعبة الجارية.';

  @override
  String get saveIncompatible =>
      'تعذّر استئناف لعبة محفوظة من إصدار أقدم، لذا تم حذفها.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String removeAdsWithPrice(String price) {
    return 'إزالة الإعلانات $price';
  }

  @override
  String get removeAdsDesc => 'شراء واحد، بلا إعلانات إلى الأبد';

  @override
  String get removeAdsLongDesc =>
      'أزل جميع الإعلانات نهائيًا بعملية شراء واحدة وركّز تمامًا على اللغز.';

  @override
  String get adsRemoved => 'تمت إزالة الإعلانات';

  @override
  String get purchasePending => 'جارٍ المعالجة';

  @override
  String get storeUnavailable => 'تعذّر الاتصال بالمتجر';

  @override
  String get restorePurchases => 'استعادة المشتريات';

  @override
  String get restoreRequested => 'جارٍ التحقق من سجل مشترياتك';

  @override
  String get purchaseFailed => 'تعذّر إتمام الدفع. يُرجى المحاولة لاحقًا';

  @override
  String get restoreFailed => 'تعذّرت استعادة المشتريات. يُرجى المحاولة لاحقًا';

  @override
  String get restoreNone => 'لا توجد مشتريات لاستعادتها';

  @override
  String get resultRemoveAdsLine => 'هل تريد اللعب بلا إعلانات؟';

  @override
  String get chooseDifficulty => 'اختر مستوى الصعوبة';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'تنتهي اللعبة بعد $max خطأ · التراجع لا يقلل الأخطاء',
      many: 'تنتهي اللعبة بعد $max خطأً · التراجع لا يقلل الأخطاء',
      few: 'تنتهي اللعبة بعد $max أخطاء · التراجع لا يقلل الأخطاء',
      two: 'تنتهي اللعبة بعد $max خطأين · التراجع لا يقلل الأخطاء',
      one: 'تنتهي اللعبة بعد $max خطأ · التراجع لا يقلل الأخطاء',
      zero: 'تنتهي اللعبة بعد $max خطأ · التراجع لا يقلل الأخطاء',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'سنبدأ بعد قليل';

  @override
  String get preparingSub => 'جارٍ إنشاء لغز جديد…';

  @override
  String get puzzleFailed => 'تعذّر إنشاء اللغز. يُرجى المحاولة مرة أخرى';

  @override
  String get back => 'رجوع';

  @override
  String get more => 'المزيد';

  @override
  String get restartSame => 'إعادة اللغز';

  @override
  String get restartConfirmTitle => 'هل تريد إعادة هذا اللغز من البداية؟';

  @override
  String get restartConfirmBody =>
      'ستتم إعادة تعيين الأرقام المُدخلة والوقت والأخطاء.';

  @override
  String get instantCheck => 'التحقق الفوري';

  @override
  String mistakes(int count, int max) {
    return 'الأخطاء $count/$max';
  }

  @override
  String get undo => 'تراجع';

  @override
  String get erase => 'مسح';

  @override
  String get memo => 'ملاحظات';

  @override
  String get memoOn => 'ملاحظات مفعّلة';

  @override
  String get mistakeKept => 'التراجع لا يقلل عدد الأخطاء';

  @override
  String cellEmpty(int row, int column) {
    return 'الصف $row، العمود $column، فارغ';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'الصف $row، العمود $column، $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number، متبقٍ $count';
  }

  @override
  String get cleared => 'تم الحل!';

  @override
  String get gameOver => 'انتهت اللعبة';

  @override
  String clearedSub(String difficulty) {
    return 'أكملت مستوى $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'وصلت إلى $max خطأ',
      many: 'وصلت إلى $max خطأً',
      few: 'وصلت إلى $max أخطاء',
      two: 'وصلت إلى $max خطأين',
      one: 'وصلت إلى $max خطأ',
      zero: 'وصلت إلى $max خطأ',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 رقم قياسي جديد';

  @override
  String get time => 'الوقت';

  @override
  String get mistakeCount => 'الأخطاء';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرة',
      many: '$count مرة',
      few: '$count مرات',
      two: '$count مرتان',
      one: '$count مرة',
      zero: '$count مرة',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'الصعوبة';

  @override
  String get home => 'الرئيسية';

  @override
  String get all => 'الكل';

  @override
  String get bestRecords => 'أفضل الأوقات';

  @override
  String get bestRecordsSub => 'أسرع وقت حل لكل مستوى';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'السجلات الأخيرة ($count)',
      many: 'السجلات الأخيرة ($count)',
      few: 'السجلات الأخيرة ($count)',
      two: 'السجلات الأخيرة ($count)',
      one: 'السجلات الأخيرة ($count)',
      zero: 'السجلات الأخيرة ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'لا توجد سجلات بعد';

  @override
  String get noRecordsSub => 'حُلّ لغزًا لتراه هنا';

  @override
  String get clearTime => 'وقت الحل';

  @override
  String get checkOff => 'بلا تحقق';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خطأ',
      many: '$count خطأً',
      few: '$count أخطاء',
      two: '$count خطأان',
      one: '$count خطأ',
      zero: '$count خطأ',
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
  String get clearAll => 'حذف الكل';

  @override
  String get clearAllTitle => 'هل تريد حذف جميع السجلات؟';

  @override
  String get clearAllBody => 'لا يمكن استعادة السجلات المحذوفة.';

  @override
  String get delete => 'حذف';

  @override
  String get instantCheckDefault => 'التحقق الفوري افتراضيًا';

  @override
  String get instantCheckDesc => 'إظهار الإدخالات الخاطئة فور إدخالها';

  @override
  String get soundEffects => 'المؤثرات الصوتية';

  @override
  String get soundEffectsDesc => 'أصوات الإدخال والخطأ والإكمال';

  @override
  String get privacyOptions => 'خيارات الخصوصية';

  @override
  String get privacyOptionsDesc =>
      'راجع إعدادات موافقتك على الإعلانات أو غيّرها';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get openLinkFailed => 'تعذّر فتح الرابط';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get footer => 'سودوكو (Sudoku JANG)';

  @override
  String get difficultyEasy => 'سهل';

  @override
  String get difficultyNormal => 'متوسط';

  @override
  String get difficultyHard => 'صعب';

  @override
  String get difficultyExpert => 'خبير';

  @override
  String get difficultyHell => 'جحيم';
}
