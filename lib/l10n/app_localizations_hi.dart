// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'सुडोकू';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'शांत एकाग्रता, दिमाग के लिए रोज़ का आराम';

  @override
  String get newGame => 'नया गेम';

  @override
  String get records => 'रिकॉर्ड';

  @override
  String get settings => 'सेटिंग';

  @override
  String get continueTitle => 'जारी गेम';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString पूरा · $time बीता';
  }

  @override
  String get overwriteTitle => 'नया गेम शुरू करें?';

  @override
  String get overwriteBody => 'जारी गेम मिट जाएगा।';

  @override
  String get saveIncompatible =>
      'पुराने वर्शन का सहेजा गया गेम जारी नहीं हो सका, इसलिए उसे हटा दिया गया।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get removeAds => 'विज्ञापन हटाएं';

  @override
  String removeAdsWithPrice(String price) {
    return 'विज्ञापन हटाएं $price';
  }

  @override
  String get removeAdsDesc => 'एक बार खरीदें, हमेशा के लिए विज्ञापन-मुक्त';

  @override
  String get removeAdsLongDesc =>
      'एक ही खरीदारी से सभी विज्ञापन हमेशा के लिए हटाएं और पूरी तरह पहेली पर ध्यान दें।';

  @override
  String get adsRemoved => 'विज्ञापन हटा दिए गए';

  @override
  String get purchasePending => 'प्रोसेस हो रहा है';

  @override
  String get storeUnavailable => 'स्टोर से कनेक्ट नहीं हो सका';

  @override
  String get restorePurchases => 'खरीदारी बहाल करें';

  @override
  String get restoreRequested => 'आपकी खरीदारी का इतिहास जांचा जा रहा है';

  @override
  String get purchaseFailed =>
      'भुगतान पूरा नहीं हो सका। कृपया बाद में फिर कोशिश करें';

  @override
  String get restoreFailed =>
      'खरीदारी बहाल नहीं हो सकी। कृपया बाद में फिर कोशिश करें';

  @override
  String get restoreNone => 'बहाल करने के लिए कोई खरीदारी नहीं';

  @override
  String get resultRemoveAdsLine => 'बिना विज्ञापन खेलना चाहते हैं?';

  @override
  String get chooseDifficulty => 'कठिनाई चुनें';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '$max गलतियों पर गेम खत्म · पूर्ववत करने से गलतियां कम नहीं होतीं',
      one: '$max गलती पर गेम खत्म · पूर्ववत करने से गलतियां कम नहीं होतीं',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'जल्द शुरू हो रहा है';

  @override
  String get preparingSub => 'नई पहेली बनाई जा रही है…';

  @override
  String get puzzleFailed => 'पहेली नहीं बन सकी। कृपया फिर कोशिश करें';

  @override
  String get back => 'वापस';

  @override
  String get more => 'और';

  @override
  String get restartSame => 'फिर से शुरू';

  @override
  String get restartConfirmTitle => 'यह पहेली शुरू से खेलें?';

  @override
  String get restartConfirmBody =>
      'भरे गए अंक, समय और गलतियां सब रीसेट हो जाएंगी।';

  @override
  String get instantCheck => 'तुरंत जांच';

  @override
  String mistakes(int count, int max) {
    return 'गलतियां $count/$max';
  }

  @override
  String get undo => 'पूर्ववत';

  @override
  String get erase => 'मिटाएं';

  @override
  String get memo => 'नोट्स';

  @override
  String get memoOn => 'नोट्स चालू';

  @override
  String get mistakeKept => 'पूर्ववत करने से गलतियों की गिनती कम नहीं होती';

  @override
  String cellEmpty(int row, int column) {
    return 'पंक्ति $row, कॉलम $column, खाली';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'पंक्ति $row, कॉलम $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, $count बाकी';
  }

  @override
  String get cleared => 'हल हो गया!';

  @override
  String get gameOver => 'गेम खत्म';

  @override
  String clearedSub(String difficulty) {
    return 'आपने $difficulty कठिनाई पूरी की';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'आप $max गलतियों तक पहुंच गए',
      one: 'आप $max गलती तक पहुंच गए',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 नया रिकॉर्ड';

  @override
  String get time => 'समय';

  @override
  String get mistakeCount => 'गलतियां';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बार',
      one: '$count बार',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'कठिनाई';

  @override
  String get home => 'होम';

  @override
  String get all => 'सभी';

  @override
  String get bestRecords => 'सबसे अच्छा समय';

  @override
  String get bestRecordsSub => 'हर कठिनाई में सबसे तेज़ समय';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हाल के रिकॉर्ड ($count)',
      one: 'हाल का रिकॉर्ड ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'अभी कोई रिकॉर्ड नहीं';

  @override
  String get noRecordsSub => 'पहेली हल करें, वह यहां दिखेगी';

  @override
  String get clearTime => 'हल करने का समय';

  @override
  String get checkOff => 'जांच बंद';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गलतियां',
      one: '$count गलती',
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
  String get clearAll => 'सब हटाएं';

  @override
  String get clearAllTitle => 'सभी रिकॉर्ड हटाएं?';

  @override
  String get clearAllBody => 'हटाए गए रिकॉर्ड वापस नहीं लाए जा सकते।';

  @override
  String get delete => 'हटाएं';

  @override
  String get instantCheckDefault => 'डिफ़ॉल्ट रूप से तुरंत जांच';

  @override
  String get instantCheckDesc => 'गलत अंक भरते ही दिखाएं';

  @override
  String get soundEffects => 'ध्वनि प्रभाव';

  @override
  String get soundEffectsDesc => 'इनपुट, गलती और पूरा होने की ध्वनियाँ';

  @override
  String get privacyOptions => 'निजता विकल्प';

  @override
  String get privacyOptionsDesc => 'विज्ञापन सहमति सेटिंग देखें या बदलें';

  @override
  String get privacyPolicy => 'निजता नीति';

  @override
  String get openLinkFailed => 'लिंक नहीं खुल सका';

  @override
  String get appVersion => 'ऐप वर्शन';

  @override
  String get footer => 'सुडोकू (Sudoku JANG)';

  @override
  String get difficultyEasy => 'आसान';

  @override
  String get difficultyNormal => 'सामान्य';

  @override
  String get difficultyHard => 'कठिन';

  @override
  String get difficultyExpert => 'विशेषज्ञ';

  @override
  String get difficultyHell => 'नरक';
}
