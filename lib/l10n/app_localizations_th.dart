// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'ซูโดกุ';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'จดจ่ออย่างสงบ พักสมองในทุกวัน';

  @override
  String get newGame => 'เกมใหม่';

  @override
  String get records => 'สถิติ';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get continueTitle => 'เกมที่เล่นค้างไว้';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'เสร็จ $progressString · ผ่านไป $time';
  }

  @override
  String get overwriteTitle => 'เริ่มเกมใหม่ไหม';

  @override
  String get overwriteBody => 'เกมที่เล่นค้างไว้จะหายไป';

  @override
  String get saveIncompatible =>
      'ไม่สามารถเล่นเกมที่บันทึกจากเวอร์ชันเก่าต่อได้ จึงลบออกแล้ว';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get removeAds => 'ลบโฆษณา';

  @override
  String removeAdsWithPrice(String price) {
    return 'ลบโฆษณา $price';
  }

  @override
  String get removeAdsDesc => 'ซื้อครั้งเดียว ไม่มีโฆษณาตลอดไป';

  @override
  String get removeAdsLongDesc =>
      'ลบโฆษณาทั้งหมดอย่างถาวรด้วยการซื้อครั้งเดียว แล้วจดจ่อกับปริศนาได้เต็มที่';

  @override
  String get adsRemoved => 'ลบโฆษณาแล้ว';

  @override
  String get purchasePending => 'กำลังดำเนินการ';

  @override
  String get storeUnavailable => 'เชื่อมต่อสโตร์ไม่ได้';

  @override
  String get restorePurchases => 'กู้คืนการซื้อ';

  @override
  String get restoreRequested => 'กำลังตรวจสอบประวัติการซื้อ';

  @override
  String get purchaseFailed => 'ชำระเงินไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get restoreFailed => 'กู้คืนการซื้อไม่สำเร็จ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get restoreNone => 'ไม่มีการซื้อให้กู้คืน';

  @override
  String get resultRemoveAdsLine => 'อยากเล่นแบบไม่มีโฆษณาไหม';

  @override
  String get chooseDifficulty => 'เลือกระดับความยาก';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'ผิด $max ครั้งจะจบเกม · การเลิกทำไม่ลดจำนวนครั้งที่ผิด',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'กำลังจะเริ่ม';

  @override
  String get preparingSub => 'กำลังสร้างปริศนาใหม่…';

  @override
  String get puzzleFailed => 'สร้างปริศนาไม่ได้ โปรดลองอีกครั้ง';

  @override
  String get back => 'กลับ';

  @override
  String get more => 'เพิ่มเติม';

  @override
  String get restartSame => 'เริ่มใหม่';

  @override
  String get restartConfirmTitle => 'เริ่มปริศนานี้ใหม่ตั้งแต่ต้นไหม';

  @override
  String get restartConfirmBody =>
      'ตัวเลขที่กรอก เวลา และจำนวนครั้งที่ผิดจะถูกรีเซ็ต';

  @override
  String get instantCheck => 'ตรวจทันที';

  @override
  String mistakes(int count, int max) {
    return 'ผิด $count/$max';
  }

  @override
  String get undo => 'เลิกทำ';

  @override
  String get erase => 'ลบ';

  @override
  String get memo => 'โน้ต';

  @override
  String get memoOn => 'โน้ต เปิด';

  @override
  String get mistakeKept => 'การเลิกทำไม่ลดจำนวนครั้งที่ผิด';

  @override
  String cellEmpty(int row, int column) {
    return 'แถว $row คอลัมน์ $column ว่าง';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'แถว $row คอลัมน์ $column $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number เหลือ $count';
  }

  @override
  String get cleared => 'สำเร็จ!';

  @override
  String get gameOver => 'จบเกม';

  @override
  String clearedSub(String difficulty) {
    return 'คุณผ่านระดับ$difficultyแล้ว';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'คุณผิดครบ $max ครั้งแล้ว',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 สถิติใหม่';

  @override
  String get time => 'เวลา';

  @override
  String get mistakeCount => 'ผิด';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ครั้ง',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'ระดับ';

  @override
  String get home => 'หน้าหลัก';

  @override
  String get all => 'ทั้งหมด';

  @override
  String get bestRecords => 'เวลาดีที่สุด';

  @override
  String get bestRecordsSub => 'เวลาที่เร็วที่สุดของแต่ละระดับ';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'สถิติล่าสุด ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'ยังไม่มีสถิติ';

  @override
  String get noRecordsSub => 'แก้ปริศนาให้สำเร็จเพื่อดูที่นี่';

  @override
  String get clearTime => 'เวลาที่ใช้';

  @override
  String get checkOff => 'ไม่ตรวจ';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ผิด $count ครั้ง',
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
  String get clearAll => 'ลบทั้งหมด';

  @override
  String get clearAllTitle => 'ลบสถิติทั้งหมดไหม';

  @override
  String get clearAllBody => 'สถิติที่ลบแล้วจะกู้คืนไม่ได้';

  @override
  String get delete => 'ลบ';

  @override
  String get instantCheckDefault => 'ตรวจทันทีเป็นค่าเริ่มต้น';

  @override
  String get instantCheckDesc => 'แสดงคำตอบผิดทันทีที่กรอก';

  @override
  String get soundEffects => 'เอฟเฟกต์เสียง';

  @override
  String get soundEffectsDesc => 'เสียงเมื่อกรอก ผิดพลาด และแก้สำเร็จ';

  @override
  String get privacyOptions => 'ตัวเลือกความเป็นส่วนตัว';

  @override
  String get privacyOptionsDesc =>
      'ตรวจสอบหรือเปลี่ยนการตั้งค่าความยินยอมด้านโฆษณา';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get openLinkFailed => 'เปิดลิงก์ไม่ได้';

  @override
  String get appVersion => 'เวอร์ชันแอป';

  @override
  String get footer => 'ซูโดกุ (Sudoku JANG)';

  @override
  String get difficultyEasy => 'ง่าย';

  @override
  String get difficultyNormal => 'ปานกลาง';

  @override
  String get difficultyHard => 'ยาก';

  @override
  String get difficultyExpert => 'ผู้เชี่ยวชาญ';

  @override
  String get difficultyHell => 'นรก';
}
