// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Tập trung nhẹ nhàng, phút nghỉ mỗi ngày cho trí óc';

  @override
  String get newGame => 'Ván mới';

  @override
  String get records => 'Thành tích';

  @override
  String get settings => 'Cài đặt';

  @override
  String get continueTitle => 'Ván đang chơi';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'Hoàn thành $progressString · đã chơi $time';
  }

  @override
  String get overwriteTitle => 'Bắt đầu ván mới?';

  @override
  String get overwriteBody => 'Ván đang chơi sẽ bị mất.';

  @override
  String get saveIncompatible =>
      'Không thể tiếp tục ván đã lưu từ phiên bản cũ nên ván đó đã bị xóa.';

  @override
  String get cancel => 'Hủy';

  @override
  String get removeAds => 'Xóa quảng cáo';

  @override
  String removeAdsWithPrice(String price) {
    return 'Xóa quảng cáo $price';
  }

  @override
  String get removeAdsDesc => 'Mua một lần, không quảng cáo mãi mãi';

  @override
  String get removeAdsLongDesc =>
      'Xóa vĩnh viễn mọi quảng cáo chỉ với một lần mua và tập trung hoàn toàn vào câu đố.';

  @override
  String get adsRemoved => 'Đã xóa quảng cáo';

  @override
  String get purchasePending => 'Đang xử lý';

  @override
  String get storeUnavailable => 'Không thể kết nối với cửa hàng';

  @override
  String get restorePurchases => 'Khôi phục giao dịch mua';

  @override
  String get restoreRequested => 'Đang kiểm tra lịch sử mua hàng';

  @override
  String get purchaseFailed =>
      'Không thể hoàn tất thanh toán. Vui lòng thử lại sau';

  @override
  String get restoreFailed =>
      'Không thể khôi phục giao dịch mua. Vui lòng thử lại sau';

  @override
  String get restoreNone => 'Không có giao dịch mua nào để khôi phục';

  @override
  String get resultRemoveAdsLine => 'Muốn chơi không có quảng cáo?';

  @override
  String get chooseDifficulty => 'Chọn độ khó';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Thua sau $max lỗi · Hoàn tác không giảm số lỗi',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Sắp bắt đầu';

  @override
  String get preparingSub => 'Đang tạo câu đố mới…';

  @override
  String get puzzleFailed => 'Không thể tạo câu đố. Vui lòng thử lại';

  @override
  String get back => 'Quay lại';

  @override
  String get more => 'Thêm';

  @override
  String get restartSame => 'Chơi lại';

  @override
  String get restartConfirmTitle => 'Chơi lại câu đố này từ đầu?';

  @override
  String get restartConfirmBody =>
      'Số đã nhập, thời gian và số lỗi sẽ được đặt lại.';

  @override
  String get instantCheck => 'Kiểm tra ngay';

  @override
  String mistakes(int count, int max) {
    return 'Lỗi $count/$max';
  }

  @override
  String get undo => 'Hoàn tác';

  @override
  String get erase => 'Xóa';

  @override
  String get memo => 'Ghi chú';

  @override
  String get memoOn => 'Ghi chú BẬT';

  @override
  String get mistakeKept => 'Hoàn tác không làm giảm số lỗi';

  @override
  String cellEmpty(int row, int column) {
    return 'Hàng $row, cột $column, trống';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Hàng $row, cột $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, còn $count';
  }

  @override
  String get cleared => 'Hoàn thành!';

  @override
  String get gameOver => 'Thua cuộc';

  @override
  String clearedSub(String difficulty) {
    return 'Bạn đã vượt qua độ khó $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Bạn đã mắc $max lỗi',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Kỷ lục mới';

  @override
  String get time => 'Thời gian';

  @override
  String get mistakeCount => 'Lỗi';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lần',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Độ khó';

  @override
  String get home => 'Trang chủ';

  @override
  String get all => 'Tất cả';

  @override
  String get bestRecords => 'Thời gian tốt nhất';

  @override
  String get bestRecordsSub => 'Thời gian nhanh nhất theo độ khó';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ván gần đây ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Chưa có thành tích';

  @override
  String get noRecordsSub => 'Giải một câu đố để xem tại đây';

  @override
  String get clearTime => 'Thời gian giải';

  @override
  String get checkOff => 'Không kiểm tra';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lỗi',
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
  String get clearAll => 'Xóa tất cả';

  @override
  String get clearAllTitle => 'Xóa tất cả thành tích?';

  @override
  String get clearAllBody => 'Không thể khôi phục thành tích đã xóa.';

  @override
  String get delete => 'Xóa';

  @override
  String get instantCheckDefault => 'Mặc định kiểm tra ngay';

  @override
  String get instantCheckDesc => 'Hiển thị số sai ngay khi nhập';

  @override
  String get soundEffects => 'Hiệu ứng âm thanh';

  @override
  String get soundEffectsDesc => 'Âm thanh khi nhập, sai và hoàn thành';

  @override
  String get privacyOptions => 'Tùy chọn quyền riêng tư';

  @override
  String get privacyOptionsDesc =>
      'Xem lại hoặc thay đổi cài đặt đồng ý quảng cáo';

  @override
  String get privacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get openLinkFailed => 'Không thể mở liên kết';

  @override
  String get appVersion => 'Phiên bản ứng dụng';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Dễ';

  @override
  String get difficultyNormal => 'Vừa';

  @override
  String get difficultyHard => 'Khó';

  @override
  String get difficultyExpert => 'Chuyên gia';

  @override
  String get difficultyHell => 'Địa ngục';
}
