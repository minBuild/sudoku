// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '数独';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => '沉静专注，给大脑每日的休憩';

  @override
  String get newGame => '新游戏';

  @override
  String get records => '记录';

  @override
  String get settings => '设置';

  @override
  String get continueTitle => '进行中的游戏';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '已完成 $progressString · 用时 $time';
  }

  @override
  String get overwriteTitle => '开始新游戏？';

  @override
  String get overwriteBody => '进行中的游戏将会丢失。';

  @override
  String get saveIncompatible => '旧版本保存的游戏无法继续，已将其删除。';

  @override
  String get cancel => '取消';

  @override
  String get removeAds => '去除广告';

  @override
  String removeAdsWithPrice(String price) {
    return '去除广告 $price';
  }

  @override
  String get removeAdsDesc => '一次购买，永久无广告';

  @override
  String get removeAdsLongDesc => '只需一次购买即可永久去除所有广告，全心投入解题。';

  @override
  String get adsRemoved => '已去除广告';

  @override
  String get purchasePending => '处理中';

  @override
  String get storeUnavailable => '无法连接到商店';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get restoreRequested => '正在查询购买记录';

  @override
  String get purchaseFailed => '未能完成付款，请稍后重试';

  @override
  String get restoreFailed => '恢复购买失败，请稍后重试';

  @override
  String get restoreNone => '没有可恢复的购买';

  @override
  String get resultRemoveAdsLine => '想要无广告畅玩吗？';

  @override
  String get chooseDifficulty => '选择难度';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '出错 $max 次即游戏结束 · 撤销不会减少错误次数',
    );
    return '$_temp0';
  }

  @override
  String get preparing => '即将开始';

  @override
  String get preparingSub => '正在生成新的谜题…';

  @override
  String get puzzleFailed => '无法生成谜题，请重试';

  @override
  String get back => '返回';

  @override
  String get more => '更多';

  @override
  String get restartSame => '重玩本题';

  @override
  String get restartConfirmTitle => '要从头重玩本题吗？';

  @override
  String get restartConfirmBody => '已填数字、用时和错误次数都将重置。';

  @override
  String get instantCheck => '即时检查';

  @override
  String mistakes(int count, int max) {
    return '错误 $count/$max';
  }

  @override
  String get undo => '撤销';

  @override
  String get erase => '擦除';

  @override
  String get memo => '笔记';

  @override
  String get memoOn => '笔记 开';

  @override
  String get mistakeKept => '撤销不会减少错误次数';

  @override
  String cellEmpty(int row, int column) {
    return '第 $row 行第 $column 列，空';
  }

  @override
  String cellValue(int row, int column, int value) {
    return '第 $row 行第 $column 列，$value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number，剩余 $count 个';
  }

  @override
  String get cleared => '完成！';

  @override
  String get gameOver => '游戏结束';

  @override
  String clearedSub(String difficulty) {
    return '你已成功完成$difficulty难度';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '已出错 $max 次',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 新纪录';

  @override
  String get time => '用时';

  @override
  String get mistakeCount => '错误';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => '难度';

  @override
  String get home => '返回首页';

  @override
  String get all => '全部';

  @override
  String get bestRecords => '最佳纪录';

  @override
  String get bestRecordsSub => '各难度最快完成时间';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最近记录（$count）',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => '暂无记录';

  @override
  String get noRecordsSub => '完成谜题后会记录在这里';

  @override
  String get clearTime => '完成用时';

  @override
  String get checkOff => '未检查';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '错误 $count 次',
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
  String get clearAll => '全部删除';

  @override
  String get clearAllTitle => '要删除所有记录吗？';

  @override
  String get clearAllBody => '删除的记录无法恢复。';

  @override
  String get delete => '删除';

  @override
  String get instantCheckDefault => '默认开启即时检查';

  @override
  String get instantCheckDesc => '输入错误时立即提示';

  @override
  String get privacyOptions => '隐私选项';

  @override
  String get privacyOptionsDesc => '查看或更改广告同意设置';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get openLinkFailed => '无法打开链接';

  @override
  String get appVersion => '应用版本';

  @override
  String get footer => '数独 (Sudoku JANG)';

  @override
  String get difficultyEasy => '简单';

  @override
  String get difficultyNormal => '普通';

  @override
  String get difficultyHard => '困难';

  @override
  String get difficultyExpert => '专家';

  @override
  String get difficultyHell => '地狱';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '數獨';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => '沉靜專注，給大腦每天的休憩';

  @override
  String get newGame => '新遊戲';

  @override
  String get records => '紀錄';

  @override
  String get settings => '設定';

  @override
  String get continueTitle => '進行中的遊戲';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '已完成 $progressString · 經過 $time';
  }

  @override
  String get overwriteTitle => '要開始新遊戲嗎？';

  @override
  String get overwriteBody => '進行中的遊戲將會遺失。';

  @override
  String get saveIncompatible => '舊版本儲存的遊戲無法繼續，已將其刪除。';

  @override
  String get cancel => '取消';

  @override
  String get removeAds => '移除廣告';

  @override
  String removeAdsWithPrice(String price) {
    return '移除廣告 $price';
  }

  @override
  String get removeAdsDesc => '一次購買，永久無廣告';

  @override
  String get removeAdsLongDesc => '只要購買一次即可永久移除所有廣告，全心投入解題。';

  @override
  String get adsRemoved => '已移除廣告';

  @override
  String get purchasePending => '處理中';

  @override
  String get storeUnavailable => '無法連線至商店';

  @override
  String get restorePurchases => '恢復購買';

  @override
  String get restoreRequested => '正在查詢購買紀錄';

  @override
  String get purchaseFailed => '未能完成付款，請稍後再試';

  @override
  String get restoreFailed => '無法恢復購買，請稍後再試';

  @override
  String get restoreNone => '沒有可恢復的購買項目';

  @override
  String get resultRemoveAdsLine => '想要無廣告暢玩嗎？';

  @override
  String get chooseDifficulty => '選擇難度';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '錯誤 $max 次即遊戲結束 · 復原不會減少錯誤次數',
    );
    return '$_temp0';
  }

  @override
  String get preparing => '即將開始';

  @override
  String get preparingSub => '正在產生新的謎題…';

  @override
  String get puzzleFailed => '無法產生謎題，請再試一次';

  @override
  String get back => '返回';

  @override
  String get more => '更多';

  @override
  String get restartSame => '重玩此題';

  @override
  String get restartConfirmTitle => '要從頭重玩此題嗎？';

  @override
  String get restartConfirmBody => '已填數字、時間和錯誤次數都會重設。';

  @override
  String get instantCheck => '即時檢查';

  @override
  String mistakes(int count, int max) {
    return '錯誤 $count/$max';
  }

  @override
  String get undo => '復原';

  @override
  String get erase => '清除';

  @override
  String get memo => '筆記';

  @override
  String get memoOn => '筆記 開';

  @override
  String get mistakeKept => '復原不會減少錯誤次數';

  @override
  String cellEmpty(int row, int column) {
    return '第 $row 列第 $column 欄，空白';
  }

  @override
  String cellValue(int row, int column, int value) {
    return '第 $row 列第 $column 欄，$value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number，剩下 $count 個';
  }

  @override
  String get cleared => '完成！';

  @override
  String get gameOver => '遊戲結束';

  @override
  String clearedSub(String difficulty) {
    return '你已成功完成$difficulty難度';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '已錯誤 $max 次',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 新紀錄';

  @override
  String get time => '時間';

  @override
  String get mistakeCount => '錯誤';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => '難度';

  @override
  String get home => '回到首頁';

  @override
  String get all => '全部';

  @override
  String get bestRecords => '最佳紀錄';

  @override
  String get bestRecordsSub => '各難度最快完成時間';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最近紀錄（$count）',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => '尚無紀錄';

  @override
  String get noRecordsSub => '完成謎題後會記錄在這裡';

  @override
  String get clearTime => '完成時間';

  @override
  String get checkOff => '未檢查';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '錯誤 $count 次',
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
  String get clearAll => '全部刪除';

  @override
  String get clearAllTitle => '要刪除所有紀錄嗎？';

  @override
  String get clearAllBody => '刪除的紀錄無法復原。';

  @override
  String get delete => '刪除';

  @override
  String get instantCheckDefault => '預設開啟即時檢查';

  @override
  String get instantCheckDesc => '輸入錯誤時立即顯示';

  @override
  String get privacyOptions => '隱私權選項';

  @override
  String get privacyOptionsDesc => '查看或變更廣告同意設定';

  @override
  String get privacyPolicy => '隱私權政策';

  @override
  String get openLinkFailed => '無法開啟連結';

  @override
  String get appVersion => '應用程式版本';

  @override
  String get footer => '數獨 (Sudoku JANG)';

  @override
  String get difficultyEasy => '簡單';

  @override
  String get difficultyNormal => '普通';

  @override
  String get difficultyHard => '困難';

  @override
  String get difficultyExpert => '專家';

  @override
  String get difficultyHell => '地獄';
}
