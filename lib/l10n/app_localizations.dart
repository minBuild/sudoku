import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// 앱 제목(홈 로고)
  ///
  /// In ko, this message translates to:
  /// **'스도쿠'**
  String get appTitle;

  /// 브랜드 배지. 번역하지 않음
  ///
  /// In ko, this message translates to:
  /// **'JANG'**
  String get appBadge;

  /// 홈 화면 소개 문구
  ///
  /// In ko, this message translates to:
  /// **'정돈된 몰입, 두뇌를 위한 일상의 휴식'**
  String get tagline;

  /// 새 게임 버튼
  ///
  /// In ko, this message translates to:
  /// **'새 게임'**
  String get newGame;

  /// 기록 화면 제목·버튼
  ///
  /// In ko, this message translates to:
  /// **'기록'**
  String get records;

  /// 설정 화면 제목·버튼
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// 이어하기 카드 제목
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 게임'**
  String get continueTitle;

  /// 이어하기 카드 상세. progress 는 0~1 비율
  ///
  /// In ko, this message translates to:
  /// **'완료율 {progress} · 경과 시간 {time}'**
  String continueDetail(double progress, String time);

  /// 이어하기 덮어쓰기 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'새 게임을 시작할까요?'**
  String get overwriteTitle;

  /// 이어하기 덮어쓰기 확인 본문
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 게임이 사라져요.'**
  String get overwriteBody;

  /// 호환되지 않는 저장 삭제 안내
  ///
  /// In ko, this message translates to:
  /// **'이전 버전의 저장된 게임은 이어할 수 없어 삭제했어요.'**
  String get saveIncompatible;

  /// 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// 광고 제거 상품 이름·버튼
  ///
  /// In ko, this message translates to:
  /// **'광고 제거'**
  String get removeAds;

  /// 가격이 붙은 광고 제거 버튼. price 는 스토어가 포맷한 값
  ///
  /// In ko, this message translates to:
  /// **'광고 제거 {price}'**
  String removeAdsWithPrice(String price);

  /// 광고 제거 카드 설명
  ///
  /// In ko, this message translates to:
  /// **'한 번 구매로 평생 광고 없이'**
  String get removeAdsDesc;

  /// 설정 화면 광고 제거 설명
  ///
  /// In ko, this message translates to:
  /// **'한 번 구매로 영구적으로 모든 광고를 제거하고 온전히 퍼즐에 몰입하세요.'**
  String get removeAdsLongDesc;

  /// 광고 제거 완료 표시
  ///
  /// In ko, this message translates to:
  /// **'광고 제거됨'**
  String get adsRemoved;

  /// 결제 대기 중 표시
  ///
  /// In ko, this message translates to:
  /// **'처리 중'**
  String get purchasePending;

  /// 스토어 연결 실패
  ///
  /// In ko, this message translates to:
  /// **'스토어에 연결할 수 없어요'**
  String get storeUnavailable;

  /// 구매 복원 버튼
  ///
  /// In ko, this message translates to:
  /// **'구매 복원'**
  String get restorePurchases;

  /// 구매 복원 요청 안내
  ///
  /// In ko, this message translates to:
  /// **'구매 내역을 확인하고 있어요'**
  String get restoreRequested;

  /// 결제 실패 스낵바
  ///
  /// In ko, this message translates to:
  /// **'결제를 완료하지 못했어요. 잠시 후 다시 시도해 주세요'**
  String get purchaseFailed;

  /// 구매 복원 실패 스낵바
  ///
  /// In ko, this message translates to:
  /// **'구매 복원에 실패했어요. 잠시 후 다시 시도해 주세요'**
  String get restoreFailed;

  /// 복원할 구매 없음 스낵바
  ///
  /// In ko, this message translates to:
  /// **'복원할 구매가 없어요'**
  String get restoreNone;

  /// 결과 시트 광고 제거 권유
  ///
  /// In ko, this message translates to:
  /// **'광고 없는 플레이를 원하시나요?'**
  String get resultRemoveAdsLine;

  /// 난이도 시트 제목
  ///
  /// In ko, this message translates to:
  /// **'난이도 선택'**
  String get chooseDifficulty;

  /// 난이도 시트 규칙 안내
  ///
  /// In ko, this message translates to:
  /// **'{max, plural, other{실수 {max}번이면 게임 오버 · 되돌리기로 실수 횟수는 줄지 않아요}}'**
  String difficultyRule(int max);

  /// 퍼즐 준비 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'잠시 후 시작됩니다'**
  String get preparing;

  /// 퍼즐 준비 화면 설명
  ///
  /// In ko, this message translates to:
  /// **'새로운 퍼즐을 생성하고 있습니다…'**
  String get preparingSub;

  /// 퍼즐 생성 실패 스낵바
  ///
  /// In ko, this message translates to:
  /// **'퍼즐을 만들지 못했어요. 다시 시도해 주세요'**
  String get puzzleFailed;

  /// 뒤로 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'뒤로'**
  String get back;

  /// 더보기 메뉴 툴팁
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get more;

  /// 같은 퍼즐 다시 시작
  ///
  /// In ko, this message translates to:
  /// **'같은 퍼즐 다시'**
  String get restartSame;

  /// 재시작 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'같은 퍼즐을 처음부터 할까요?'**
  String get restartConfirmTitle;

  /// 재시작 확인 본문
  ///
  /// In ko, this message translates to:
  /// **'입력한 숫자와 시간, 실수 횟수가 모두 초기화돼요.'**
  String get restartConfirmBody;

  /// 즉시 체크 메뉴
  ///
  /// In ko, this message translates to:
  /// **'즉시 체크'**
  String get instantCheck;

  /// 게임 화면 실수 표시
  ///
  /// In ko, this message translates to:
  /// **'실수 {count}/{max}'**
  String mistakes(int count, int max);

  /// 되돌리기 도구
  ///
  /// In ko, this message translates to:
  /// **'되돌리기'**
  String get undo;

  /// 지우기 도구
  ///
  /// In ko, this message translates to:
  /// **'지우기'**
  String get erase;

  /// 메모 도구
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get memo;

  /// 메모 도구 켜짐
  ///
  /// In ko, this message translates to:
  /// **'메모 ON'**
  String get memoOn;

  /// 되돌리기 후 실수 유지 안내
  ///
  /// In ko, this message translates to:
  /// **'실수 횟수는 되돌려도 유지돼요'**
  String get mistakeKept;

  /// 빈 셀 스크린리더 라벨
  ///
  /// In ko, this message translates to:
  /// **'{row}행 {column}열, 빈 칸'**
  String cellEmpty(int row, int column);

  /// 숫자 셀 스크린리더 라벨
  ///
  /// In ko, this message translates to:
  /// **'{row}행 {column}열, {value}'**
  String cellValue(int row, int column, int value);

  /// 숫자 패드 스크린리더 라벨
  ///
  /// In ko, this message translates to:
  /// **'{number}, 남은 개수 {count}'**
  String remainingLabel(int number, int count);

  /// 클리어 결과 제목
  ///
  /// In ko, this message translates to:
  /// **'클리어!'**
  String get cleared;

  /// 게임 오버 결과 제목
  ///
  /// In ko, this message translates to:
  /// **'게임 오버'**
  String get gameOver;

  /// 클리어 결과 설명
  ///
  /// In ko, this message translates to:
  /// **'{difficulty} 난이도를 성공적으로 완료했습니다'**
  String clearedSub(String difficulty);

  /// 게임 오버 결과 설명
  ///
  /// In ko, this message translates to:
  /// **'{max, plural, other{실수 {max}번에 도달했어요}}'**
  String gameOverSub(int max);

  /// 새 최고 기록 배지
  ///
  /// In ko, this message translates to:
  /// **'🏆 새 기록'**
  String get newBest;

  /// 결과 시트 시간 항목
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get time;

  /// 결과 시트 실수 항목
  ///
  /// In ko, this message translates to:
  /// **'실수'**
  String get mistakeCount;

  /// 결과 시트 실수 횟수
  ///
  /// In ko, this message translates to:
  /// **'{count, plural, other{{count}회}}'**
  String mistakeTimes(int count);

  /// 결과 시트 난이도 항목
  ///
  /// In ko, this message translates to:
  /// **'난이도'**
  String get difficulty;

  /// 홈으로 버튼
  ///
  /// In ko, this message translates to:
  /// **'홈 화면으로'**
  String get home;

  /// 기록 필터 전체
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get all;

  /// 최고 기록 제목
  ///
  /// In ko, this message translates to:
  /// **'최고 기록'**
  String get bestRecords;

  /// 최고 기록 설명
  ///
  /// In ko, this message translates to:
  /// **'난이도별 최단 클리어 시간'**
  String get bestRecordsSub;

  /// 최근 기록 제목
  ///
  /// In ko, this message translates to:
  /// **'{count, plural, other{최근 기록 ({count})}}'**
  String recentRecords(int count);

  /// 기록 없음 제목
  ///
  /// In ko, this message translates to:
  /// **'아직 기록이 없어요'**
  String get noRecords;

  /// 기록 없음 설명
  ///
  /// In ko, this message translates to:
  /// **'퍼즐을 클리어하면 여기에 기록돼요'**
  String get noRecordsSub;

  /// 기록 카드 클리어 시간
  ///
  /// In ko, this message translates to:
  /// **'클리어 시간'**
  String get clearTime;

  /// 즉시 체크 끔 배지
  ///
  /// In ko, this message translates to:
  /// **'체크 끔'**
  String get checkOff;

  /// 기록 카드 실수 횟수
  ///
  /// In ko, this message translates to:
  /// **'{count, plural, other{실수 {count}회}}'**
  String recordMistakes(int count);

  /// 기록 카드 날짜(월·일)
  ///
  /// In ko, this message translates to:
  /// **'{date}'**
  String recordDate(DateTime date);

  /// 기록 전체 삭제 툴팁
  ///
  /// In ko, this message translates to:
  /// **'전체 삭제'**
  String get clearAll;

  /// 기록 전체 삭제 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'기록을 모두 삭제할까요?'**
  String get clearAllTitle;

  /// 기록 전체 삭제 확인 본문
  ///
  /// In ko, this message translates to:
  /// **'삭제한 기록은 되돌릴 수 없어요.'**
  String get clearAllBody;

  /// 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// 설정 즉시 체크 기본값
  ///
  /// In ko, this message translates to:
  /// **'즉시 체크 기본값'**
  String get instantCheckDefault;

  /// 설정 즉시 체크 설명
  ///
  /// In ko, this message translates to:
  /// **'오답을 입력하는 즉시 표시합니다'**
  String get instantCheckDesc;

  /// 개인정보 옵션(UMP). 법적 문구, 사람 검수 필요
  ///
  /// In ko, this message translates to:
  /// **'개인정보 옵션'**
  String get privacyOptions;

  /// 개인정보 옵션 설명. 의미 축소·과장 금지, 사람 검수 필요
  ///
  /// In ko, this message translates to:
  /// **'광고 동의 설정을 확인하거나 변경합니다'**
  String get privacyOptionsDesc;

  /// 설정의 개인정보처리방침 링크. 법적 문구, 사람 검수 필요
  ///
  /// In ko, this message translates to:
  /// **'개인정보처리방침'**
  String get privacyPolicy;

  /// 외부 링크 열기 실패 스낵바
  ///
  /// In ko, this message translates to:
  /// **'링크를 열 수 없어요'**
  String get openLinkFailed;

  /// 앱 버전 항목
  ///
  /// In ko, this message translates to:
  /// **'앱 버전'**
  String get appVersion;

  /// 설정 하단 앱 이름, 앱 창 제목
  ///
  /// In ko, this message translates to:
  /// **'스도쿠 장 (Sudoku JANG)'**
  String get footer;

  /// 난이도: 쉬움
  ///
  /// In ko, this message translates to:
  /// **'쉬움'**
  String get difficultyEasy;

  /// 난이도: 보통
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get difficultyNormal;

  /// 난이도: 어려움
  ///
  /// In ko, this message translates to:
  /// **'어려움'**
  String get difficultyHard;

  /// 난이도: 전문가
  ///
  /// In ko, this message translates to:
  /// **'전문가'**
  String get difficultyExpert;

  /// 난이도: 지옥
  ///
  /// In ko, this message translates to:
  /// **'지옥'**
  String get difficultyHell;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'ko',
    'ms',
    'nb',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sv',
    'th',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
