// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'סודוקו';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'ריכוז רגוע, הפסקה יומית למחשבה';

  @override
  String get newGame => 'משחק חדש';

  @override
  String get records => 'תוצאות';

  @override
  String get settings => 'הגדרות';

  @override
  String get continueTitle => 'משחק פעיל';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'הושלמו $progressString · עברו $time';
  }

  @override
  String get overwriteTitle => 'להתחיל משחק חדש?';

  @override
  String get overwriteBody => 'המשחק הפעיל יאבד.';

  @override
  String get saveIncompatible =>
      'לא ניתן היה להמשיך משחק שמור מגרסה ישנה, ולכן הוא נמחק.';

  @override
  String get cancel => 'ביטול';

  @override
  String get removeAds => 'הסרת מודעות';

  @override
  String removeAdsWithPrice(String price) {
    return 'הסרת מודעות $price';
  }

  @override
  String get removeAdsDesc => 'רכישה אחת, בלי מודעות לתמיד';

  @override
  String get removeAdsLongDesc =>
      'הסירו את כל המודעות לצמיתות ברכישה אחת והתמקדו לגמרי בחידה.';

  @override
  String get adsRemoved => 'המודעות הוסרו';

  @override
  String get purchasePending => 'בעיבוד';

  @override
  String get storeUnavailable => 'לא ניתן להתחבר לחנות';

  @override
  String get restorePurchases => 'שחזור רכישות';

  @override
  String get restoreRequested => 'בודקים את היסטוריית הרכישות';

  @override
  String get purchaseFailed =>
      'לא ניתן היה להשלים את התשלום. נסו שוב מאוחר יותר';

  @override
  String get restoreFailed => 'לא ניתן היה לשחזר רכישות. נסו שוב מאוחר יותר';

  @override
  String get restoreNone => 'אין רכישות לשחזור';

  @override
  String get resultRemoveAdsLine => 'רוצים לשחק בלי מודעות?';

  @override
  String get chooseDifficulty => 'בחירת רמת קושי';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'המשחק נגמר אחרי $max טעויות · ביטול פעולה לא מפחית טעויות',
      two: 'המשחק נגמר אחרי $max טעויות · ביטול פעולה לא מפחית טעויות',
      one: 'המשחק נגמר אחרי טעות $max · ביטול פעולה לא מפחית טעויות',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'מתחילים בעוד רגע';

  @override
  String get preparingSub => 'יוצרים חידה חדשה…';

  @override
  String get puzzleFailed => 'לא ניתן היה ליצור חידה. נסו שוב';

  @override
  String get back => 'חזרה';

  @override
  String get more => 'עוד';

  @override
  String get restartSame => 'התחלה מחדש';

  @override
  String get restartConfirmTitle => 'להתחיל את החידה הזו מההתחלה?';

  @override
  String get restartConfirmBody => 'המספרים, הזמן והטעויות יאופסו.';

  @override
  String get instantCheck => 'בדיקה מיידית';

  @override
  String mistakes(int count, int max) {
    return 'טעויות $count/$max';
  }

  @override
  String get undo => 'ביטול פעולה';

  @override
  String get erase => 'מחיקה';

  @override
  String get memo => 'הערות';

  @override
  String get memoOn => 'הערות פעיל';

  @override
  String get mistakeKept => 'ביטול פעולה לא מפחית את מספר הטעויות';

  @override
  String cellEmpty(int row, int column) {
    return 'שורה $row, עמודה $column, ריק';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'שורה $row, עמודה $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, נותרו $count';
  }

  @override
  String get cleared => 'נפתר!';

  @override
  String get gameOver => 'המשחק נגמר';

  @override
  String clearedSub(String difficulty) {
    return 'השלמתם את רמת $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'הגעתם ל־$max טעויות',
      two: 'הגעתם ל־$max טעויות',
      one: 'הגעתם לטעות $max',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 שיא חדש';

  @override
  String get time => 'זמן';

  @override
  String get mistakeCount => 'טעויות';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count פעמים',
      two: '$count פעמים',
      one: 'פעם $count',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'רמה';

  @override
  String get home => 'בית';

  @override
  String get all => 'הכול';

  @override
  String get bestRecords => 'הזמנים הטובים';

  @override
  String get bestRecordsSub => 'הזמן המהיר ביותר לכל רמה';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'תוצאות אחרונות ($count)',
      two: 'תוצאות אחרונות ($count)',
      one: 'תוצאה אחרונה ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'עדיין אין תוצאות';

  @override
  String get noRecordsSub => 'פתרו חידה כדי לראות אותה כאן';

  @override
  String get clearTime => 'זמן פתרון';

  @override
  String get checkOff => 'ללא בדיקה';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count טעויות',
      two: '$count טעויות',
      one: 'טעות $count',
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
  String get clearAll => 'מחיקת הכול';

  @override
  String get clearAllTitle => 'למחוק את כל התוצאות?';

  @override
  String get clearAllBody => 'לא ניתן לשחזר תוצאות שנמחקו.';

  @override
  String get delete => 'מחיקה';

  @override
  String get instantCheckDefault => 'בדיקה מיידית כברירת מחדל';

  @override
  String get instantCheckDesc => 'הצגת הזנות שגויות מיד';

  @override
  String get soundEffects => 'אפקטים קוליים';

  @override
  String get soundEffectsDesc => 'צלילי הזנה, טעות וסיום';

  @override
  String get privacyOptions => 'אפשרויות פרטיות';

  @override
  String get privacyOptionsDesc => 'עיון בהגדרות ההסכמה למודעות או שינוי שלהן';

  @override
  String get privacyPolicy => 'מדיניות פרטיות';

  @override
  String get openLinkFailed => 'לא ניתן לפתוח את הקישור';

  @override
  String get appVersion => 'גרסת האפליקציה';

  @override
  String get footer => 'סודוקו (Sudoku JANG)';

  @override
  String get difficultyEasy => 'קל';

  @override
  String get difficultyNormal => 'בינוני';

  @override
  String get difficultyHard => 'קשה';

  @override
  String get difficultyExpert => 'מומחה';

  @override
  String get difficultyHell => 'גיהינום';
}
