// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '스도쿠';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => '정돈된 몰입, 두뇌를 위한 일상의 휴식';

  @override
  String get newGame => '새 게임';

  @override
  String get records => '기록';

  @override
  String get settings => '설정';

  @override
  String get continueTitle => '진행 중인 게임';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '완료율 $progressString · 경과 시간 $time';
  }

  @override
  String get overwriteTitle => '새 게임을 시작할까요?';

  @override
  String get overwriteBody => '진행 중인 게임이 사라져요.';

  @override
  String get saveIncompatible => '이전 버전의 저장된 게임은 이어할 수 없어 삭제했어요.';

  @override
  String get cancel => '취소';

  @override
  String get removeAds => '광고 제거';

  @override
  String removeAdsWithPrice(String price) {
    return '광고 제거 $price';
  }

  @override
  String get removeAdsDesc => '한 번 구매로 평생 광고 없이';

  @override
  String get removeAdsLongDesc => '한 번 구매로 영구적으로 모든 광고를 제거하고 온전히 퍼즐에 몰입하세요.';

  @override
  String get adsRemoved => '광고 제거됨';

  @override
  String get purchasePending => '처리 중';

  @override
  String get storeUnavailable => '스토어에 연결할 수 없어요';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get restoreRequested => '구매 내역을 확인하고 있어요';

  @override
  String get purchaseFailed => '결제를 완료하지 못했어요. 잠시 후 다시 시도해 주세요';

  @override
  String get restoreFailed => '구매 복원에 실패했어요. 잠시 후 다시 시도해 주세요';

  @override
  String get restoreNone => '복원할 구매가 없어요';

  @override
  String get resultRemoveAdsLine => '광고 없는 플레이를 원하시나요?';

  @override
  String get chooseDifficulty => '난이도 선택';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '실수 $max번이면 게임 오버 · 되돌리기로 실수 횟수는 줄지 않아요',
    );
    return '$_temp0';
  }

  @override
  String get preparing => '잠시 후 시작됩니다';

  @override
  String get preparingSub => '새로운 퍼즐을 생성하고 있습니다…';

  @override
  String get puzzleFailed => '퍼즐을 만들지 못했어요. 다시 시도해 주세요';

  @override
  String get back => '뒤로';

  @override
  String get more => '더보기';

  @override
  String get restartSame => '같은 퍼즐 다시';

  @override
  String get restartConfirmTitle => '같은 퍼즐을 처음부터 할까요?';

  @override
  String get restartConfirmBody => '입력한 숫자와 시간, 실수 횟수가 모두 초기화돼요.';

  @override
  String get instantCheck => '즉시 체크';

  @override
  String mistakes(int count, int max) {
    return '실수 $count/$max';
  }

  @override
  String get undo => '되돌리기';

  @override
  String get erase => '지우기';

  @override
  String get memo => '메모';

  @override
  String get memoOn => '메모 ON';

  @override
  String get mistakeKept => '실수 횟수는 되돌려도 유지돼요';

  @override
  String cellEmpty(int row, int column) {
    return '$row행 $column열, 빈 칸';
  }

  @override
  String cellValue(int row, int column, int value) {
    return '$row행 $column열, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, 남은 개수 $count';
  }

  @override
  String get cleared => '클리어!';

  @override
  String get gameOver => '게임 오버';

  @override
  String clearedSub(String difficulty) {
    return '$difficulty 난이도를 성공적으로 완료했습니다';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '실수 $max번에 도달했어요',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 새 기록';

  @override
  String get time => '시간';

  @override
  String get mistakeCount => '실수';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count회',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => '난이도';

  @override
  String get home => '홈 화면으로';

  @override
  String get all => '전체';

  @override
  String get bestRecords => '최고 기록';

  @override
  String get bestRecordsSub => '난이도별 최단 클리어 시간';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '최근 기록 ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => '아직 기록이 없어요';

  @override
  String get noRecordsSub => '퍼즐을 클리어하면 여기에 기록돼요';

  @override
  String get clearTime => '클리어 시간';

  @override
  String get checkOff => '체크 끔';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '실수 $count회',
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
  String get clearAll => '전체 삭제';

  @override
  String get clearAllTitle => '기록을 모두 삭제할까요?';

  @override
  String get clearAllBody => '삭제한 기록은 되돌릴 수 없어요.';

  @override
  String get delete => '삭제';

  @override
  String get instantCheckDefault => '즉시 체크 기본값';

  @override
  String get instantCheckDesc => '오답을 입력하는 즉시 표시합니다';

  @override
  String get privacyOptions => '개인정보 옵션';

  @override
  String get privacyOptionsDesc => '광고 동의 설정을 확인하거나 변경합니다';

  @override
  String get appVersion => '앱 버전';

  @override
  String get footer => '스도쿠 장 (Sudoku JANG)';

  @override
  String get difficultyEasy => '쉬움';

  @override
  String get difficultyNormal => '보통';

  @override
  String get difficultyHard => '어려움';

  @override
  String get difficultyExpert => '전문가';

  @override
  String get difficultyHell => '지옥';
}
