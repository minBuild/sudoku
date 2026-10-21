/// UI 문자열(한국어). 가격 숫자는 넣지 않는다 — 가격은 `ProductDetails.price` 만 표시.
abstract final class S {
  static const appTitle = '스도쿠';
  static const appBadge = 'JANG';
  static const tagline = '정돈된 몰입, 두뇌를 위한 일상의 휴식';
  static const newGame = '새 게임';
  static const records = '기록';
  static const settings = '설정';
  static const continueTitle = '진행 중인 게임';
  static String continueDetail(double progress, String time) =>
      '완료율 ${(progress * 100).round()}% · 경과 시간 $time';
  static const overwriteTitle = '새 게임을 시작할까요?';
  static const overwriteBody = '진행 중인 게임이 사라져요.';
  static const saveIncompatible = '이전 버전의 저장된 게임은 이어할 수 없어 삭제했어요.';
  static const cancel = '취소';

  static const removeAds = '광고 제거';
  static String removeAdsWithPrice(String price) => '광고 제거 $price';
  static const removeAdsDesc = '한 번 구매로 평생 광고 없이';
  static const removeAdsLongDesc = '한 번 구매로 영구적으로 모든 광고를 제거하고 온전히 퍼즐에 몰입하세요.';
  static const adsRemoved = '광고 제거됨';
  static const purchasePending = '처리 중';
  static const storeUnavailable = '스토어에 연결할 수 없어요';
  static const restorePurchases = '구매 복원';
  static const restoreRequested = '구매 내역을 확인하고 있어요';
  static const purchaseFailed = '결제를 완료하지 못했어요. 잠시 후 다시 시도해 주세요';
  static const restoreFailed = '구매 복원에 실패했어요. 잠시 후 다시 시도해 주세요';
  static const restoreNone = '복원할 구매가 없어요';
  static const resultRemoveAdsLine = '광고 없는 플레이를 원하시나요?';

  static const chooseDifficulty = '난이도 선택';
  static String difficultyRule(int max) =>
      '실수 $max번이면 게임 오버 · 되돌리기로 실수 횟수는 줄지 않아요';

  static const preparing = '잠시 후 시작됩니다';
  static const preparingSub = '새로운 퍼즐을 생성하고 있습니다…';
  static const puzzleFailed = '퍼즐을 만들지 못했어요. 다시 시도해 주세요';

  static const back = '뒤로';
  static const more = '더보기';
  static const restartSame = '같은 퍼즐 다시';
  static const restartConfirmTitle = '같은 퍼즐을 처음부터 할까요?';
  static const restartConfirmBody = '입력한 숫자와 시간, 실수 횟수가 모두 초기화돼요.';
  static const instantCheck = '즉시 체크';
  static String mistakes(int count, int max) => '실수 $count/$max';
  static const undo = '되돌리기';
  static const erase = '지우기';
  static const memo = '메모';
  static const memoOn = '메모 ON';
  static const mistakeKept = '실수 횟수는 되돌려도 유지돼요';

  /// 보드 셀의 스크린리더 라벨. [value] 가 0 이면 빈 칸.
  static String cell(int row, int column, int value) =>
      '$row행 $column열, ${value == 0 ? '빈 칸' : '$value'}';
  static String remainingLabel(int number, int count) =>
      '$number, 남은 개수 $count';

  static const cleared = '클리어!';
  static const gameOver = '게임 오버';
  static String clearedSub(String difficulty) =>
      '$difficulty 난이도를 성공적으로 완료했습니다';
  static String gameOverSub(int max) => '실수 $max번에 도달했어요';
  static const newBest = '🏆 새 기록';
  static const time = '시간';
  static const mistakeCount = '실수';
  static String mistakeTimes(int count) => '$count회';
  static const difficulty = '난이도';
  static const home = '홈 화면으로';

  static const all = '전체';
  static const bestRecords = '최고 기록';
  static const bestRecordsSub = '난이도별 최단 클리어 시간';
  static String recentRecords(int count) => '최근 기록 ($count)';
  static const noRecords = '아직 기록이 없어요';
  static const noRecordsSub = '퍼즐을 클리어하면 여기에 기록돼요';
  static const clearTime = '클리어 시간';
  static const checkOff = '체크 끔';
  static String recordMistakes(int count) => '실수 $count회';
  static String recordDate(DateTime d) => '${d.month}월 ${d.day}일';
  static const clearAll = '전체 삭제';
  static const clearAllTitle = '기록을 모두 삭제할까요?';
  static const clearAllBody = '삭제한 기록은 되돌릴 수 없어요.';
  static const delete = '삭제';

  static const instantCheckDefault = '즉시 체크 기본값';
  static const instantCheckDesc = '오답을 입력하는 즉시 표시합니다';
  static const privacyOptions = '개인정보 옵션';
  static const privacyOptionsDesc = '광고 동의 설정을 확인하거나 변경합니다';
  static const appVersion = '앱 버전';
  static const footer = '스도쿠 장 (Sudoku JANG)';
}
