# Sudoku JANG 2.0

## 맥북 출시까지 남은 일

1. ~~IAP 가격 결정~~ → **USD $0.49** 로 확정(2026-10-26, 사용자). 콘솔 등록은 3번.
2. ~~개인정보처리방침 호스팅~~ → 완료(2026-10-26). https://minbuild.github.io/sudoku/privacy.html (영어 `/sudoku/en/privacy.html`). `privacyPolicyUrl` 반영, 설정에 방침 행 표시.
3. App Store Connect 앱 생성(번들 `io.minbuild.sudoku`, **기본 언어 English(U.S.)** + 한국어 현지화)·유료 앱 계약·`remove_ads` 등록($0.49).
4. ~~맥 빌드 준비(`pod install`·서명 Team 선택)~~ → 완료(2026-10-26, 사용자). 남은 것: TestFlight·D4(테스트 기기 등록).
5. 제출.

Android는 **지금 출시하지 않습니다**(2026-10-26, 사용자). AdMob Android 앱·단위는 코드에 반영돼 있고, 출시 시점에 [출시 체크리스트](docs/release-checklist.md) Android 트랙(B·C)을 진행합니다.

**"광고 ID 다 할당됐으니 맥북에서 출시만 하면 되나?"** → 콘솔 작업(3번)과 TestFlight(4번)가 남았습니다.

| 항목 | 실제 상태 |
|---|---|
| iOS AdMob App ID·전면 단위 | 완료 (`ios/Flutter/Release.xcconfig`, `lib/services/ads/ad_ids.dart` `iosProd`) |
| Android AdMob | 2026-10-26 등록·코드 반영(`build.gradle.kts` `prodAdmobAppId`, `ad_ids.dart` `androidProd`). 맥북 iOS 출시와는 별개 트랙 |
| IAP `remove_ads` | 가격 **$0.49** 확정(2026-10-26). 콘솔 등록은 아직(F3). App Store는 IAP를 첨부하지 않으면 반려(F7) |
| 개인정보처리방침 | 호스팅 완료(2026-10-26): https://minbuild.github.io/sudoku/privacy.html, 영어 `/sudoku/en/privacy.html`. `privacyPolicyUrl` 반영, `legal_links_test` skip 0 |
| app-ads.txt | 완료: https://minbuild.github.io/app-ads.txt (다른 앱과 같은 퍼블리셔라 이미 올라가 있음) |
| 맥북 작업 | `pod install`·서명 Team 선택 완료(2026-10-26). 빌드 2.0.0 (3) 업로드·TestFlight 내부 그룹 배포 완료. Firebase pod가 추가됐으니 다음 빌드 전 `pod install` 다시 실행. 남은 것: D4(테스트 기기 등록) |
| 보상형 광고 단위(힌트·이어 도전) | **미생성 (콘솔 작업 필요)**. `ad_ids.dart` `androidRewardedProd`/`iosRewardedProd`가 `''`라 릴리스에서 보상형은 항상 사용 불가(무료 힌트·광고 제거 경로는 정상). 체크리스트 E5 |
| Firebase(주간 대결) | **미설정 (콘솔 작업 필요)**. `lib/firebase_options.dart`가 `TODO`라 주간 대결(홈 카드·설정 닉네임 행)이 숨겨짐. §[Firebase](#firebase), 체크리스트 H |
| 신고 이메일 | `lib/services/legal_links.dart` `supportEmail` = hayaeseong@gmail.com (2026-10-31 반영) → 주간 대결 화면의 "부적절한 닉네임 신고" 행 표시 |

**"한국어뿐이면 언어를 전부 추가"** → 33개 언어를 지원합니다(§[지원 언어](#지원-언어)). 33개 밖의 기기 언어는 영어로 표시됩니다.

## 개요

Flutter 스도쿠 앱. Android 먼저 출시하고, iOS는 코드와 설정을 반영했습니다(빌드 검증은 맥북: [맥북에서 할 순서](#맥북에서-할-순서)).

- 패키지명 `sudoku`, 번들·Android 앱 ID `io.minbuild.sudoku`(2026-10-26, `com.jang.sudoku`에서 변경), 버전 `2.0.0+3`
- 확인한 Flutter 버전: 3.47.7 (Dart 3.13.5). 맥북에는 3.44.7이 설치돼 있어 `flutter pub get`이 `pubspec.lock`을 내려 쓰므로, lock 변경은 커밋 전에 `git diff pubspec.lock`으로 확인한다.
- App Store Connect: Apple ID 6827115588, IAP `remove_ads`(6827120483, $0.49), 빌드 2.0.0 (3) 업로드 완료(2026-10-26). 제출 전 남은 사용자 작업은 [체크리스트](docs/release-checklist.md) iOS 트랙 5번.

## 사용자 요구 대비 동작

| 사용자 요구 | 실제 구현 | 요구와 다른 점 (사용자에게 반드시 고지) |
|---|---|---|
| "디자인부터 새로, 훨씬 깔끔하게" | 디자인 토큰(`ThemeExtension`)과 `CustomPainter` 한 장으로 그리는 보드로 라이트 테마를 새로 구성 | 다크 테마는 이번 범위가 아닙니다. 토큰 구조만 미리 만들어 둡니다. |
| "게임 시작할 때 10초 정도 광고 한 편" | 앱 실행 후 **첫 새 게임부터** AdMob 전면광고를 1회 보여 줍니다. 이후에는 마지막 노출 시각부터 **15분**(`AdSchedule.defaultInterval`)이 지난 뒤 시작하는 새 게임에만 보여 줍니다. 판 수가 아니라 시간 기준입니다(쉬움은 빨리 끝나기 때문). 판단은 새 게임을 시작하는 시점에만 하고, 게임 중에는 광고가 뜨지 않습니다. 시각은 메모리에만 두므로 앱을 다시 실행하면 첫 판부터 다시 나옵니다. 광고를 못 띄운 경우(no-fill, 오프라인, 취소)는 기록하지 않아 다음 새 게임에서 다시 시도합니다. 이어하기, 같은 퍼즐 다시, 재시작은 대상이 아닙니다. | **광고 길이는 앱이 정할 수 없습니다.** 광고 네트워크가 소재를 고르기 때문에 보통 5~30초이고, 동영상은 5초 뒤 건너뛰기가 될 수 있으며, 정적 이미지 광고가 나오면 1~2초 만에 닫힐 수도 있습니다. 광고를 받지 못하면(오프라인, 노필, 동의 거부) **광고 없이 최대 약 3초 뒤 게임이 시작됩니다.** 보상형(Rewarded) 광고는 정책상 "사용자가 선택해 보는 광고"여야 하므로 **전면광고 대체용으로는 쓰지 않고, 선택형 힌트·이어 도전에만 씁니다**(§[주간 대결·힌트·이어 도전](#주간-대결힌트이어-도전)). 광고를 10초 동안 붙잡아 두는 인위적 대기도 정책 위반 위험이 있어 넣지 않습니다. |
| "평생 광고 제거 990원(끝자리 내림 가격)" | 비소모성 상품 `remove_ads` 1개를 둡니다. 가격은 **스토어 콘솔에서** 설정하고, 앱은 스토어가 돌려주는 `ProductDetails.price`만 표시합니다. | **Google Play**: ₩990으로 바로 설정할 수 있습니다. **App Store**: Apple의 KRW 가격 목록에 ₩990이 있으면 ₩990, 없으면 **₩990 이하 가격 중 가장 높은 값**으로 정합니다. 이 경우 ₩990과 달라지므로 사용자 확인이 필요합니다. 해외 가격은 각 콘솔이 자동 환산합니다(USD 기준가 $0.99). 확정한 가격은 README §가격표에 기록합니다. 가격 정책: 끝자리 내림(기준 ₩1,000 → ₩990). |

### 사용자 확인이 필요한 변경

**사용자가 정해야 할 결정 2개**

- **결정 A — 광고 제거 가격**(이전 4·8·10 통합): **USD $0.49** 로 확정(2026-10-26, 사용자). App Store Connect에서 기준가 $0.49(가격 등급)를 고르면 KRW 등 다른 통화는 Apple이 자동 환산합니다. 결과는 §가격표에 기록합니다.
- **결정 B — 개인정보처리방침 호스팅·공개 연락처**: 완료(2026-10-26). 운영자 minBuild, 연락처 hayaeseong@gmail.com, 시행일 2026-10-26. 공개본 https://minbuild.github.io/sudoku/privacy.html (원본 `docs/privacy-policy.md`).

**고지 사항**

1. 이어하기 기능 추가 (자동 저장 1슬롯)
2. "숫자 먼저 선택" 입력 방식 삭제 → "칸 선택 → 숫자 입력"으로 통일
3. 실수 5회면 게임 오버 (기존 규칙 유지, undo로 실수 횟수가 줄지 않음)
4. (결정 A로 통합)
5. 광고 길이 미보장
6. iPhone 전용 출시(iPad 제외). 한 번 iPad 지원으로 출시하면 이후 iPad를 뺄 수 없으므로, App Store Connect에 iPad를 지원한 기존 기록이 있으면 `TARGETED_DEVICE_FAMILY`를 `"1,2"`로 되돌립니다.
7. iOS 홈 화면 이름을 `Sudoku` 그대로 둘지 `스도쿠`로 바꿀지(AdMob 앱 이름은 `스도쿠`, Android 라벨은 `sudoku JANG`)
   - 이름 불일치(AdMob `스도쿠` / iOS 홈 `Sudoku` / 스토어 `Sudoku JANG` / Android `sudoku JANG`)는 의도된 상태입니다. AdMob 앱 이름을 바꿔도 App ID는 바뀌지 않습니다.
8. (결정 A로 통합)
9. 광고 노출 정책: 첫 판부터, 15분 간격
10. (결정 A로 통합)
11. **31개 언어 AI 번역·미검수 출시**(사용자 지시). ko·en 검수와 ko·en 법적 문구(ATT·`privacyOptions*`·`privacyPolicy`) 검수는 유지합니다. 33개 밖의 기기 언어는 영어로 나옵니다.
12. 설정에 개인정보처리방침 링크 추가(`url_launcher`, 외부 브라우저). URL은 `lib/services/legal_links.dart`(minbuild.github.io).
13. Android AdMob App ID(`ca-app-pub-7432278320907197~1580424878`, 2026-10-26 등록)를 `android/app/build.gradle.kts`에 커밋합니다. App ID는 APK에 평문으로 들어가는 공개값입니다.
14. 스토어 기본 언어는 **English(U.S.)**, 한국어는 현지화로 추가합니다. 스토어는 맞는 현지화가 없으면 기본 언어를 보여 주므로, 기본이 한국어면 "없으면 영어" 규칙과 어긋납니다.

**현재 결정(2026-10-26, 사용자)**: 1회 구매 **USD $0.49**. 기준 통화는 USD이고 다른 통화는 각 콘솔이 자동 환산합니다. 앱 코드에는 가격 숫자를 넣지 않고 `ProductDetails.price`만 표시합니다. (이전 메모 ₩990·₩1,900은 폐기)

## 가격표

| 스토어 | 상품 ID | 설정 가격 | 확인일 | 앱 표시값(`ProductDetails.price`) |
|---|---|---|---|---|
| App Store | `remove_ads` | USD $0.49 (KRW는 Apple 자동 환산) | | |
| Play (출시 보류) | `remove_ads` | USD $0.49 기준 | | |

빈칸은 콘솔에 등록하고 QA를 마친 뒤 채웁니다. 가격 검증은 logcat의 `IAP price=… raw=… cur=KRW` 로그로 합니다.

## 지원 언어

33개 언어 = flutter_localizations 지원 언어 ∩ App Store Connect 메타데이터 언어입니다. 이 범위를 넘으면 iOS가 표시 언어로 고를 수 없어서 의미가 없습니다. **33개가 "모든 언어"는 아닙니다**: Android의 `sw`·`bn` 같은 언어는 영어로 나옵니다.

| 언어 | 코드 | 번역 상태 | 출시 게이트 |
|---|---|---|---|
| 한국어(템플릿) | ko | 원문 | 검수 필수 |
| 영어(폴백) | en | AI 초벌 | 검수 필수 |
| 나머지 31개 | ar ca cs da de el es fi fr he hi hr hu id it ja ms nb nl pl pt ro ru sk sv th tr uk vi zh(간체) zh_Hant(번체) | AI 번역 | 미검수 출시(사용자 확인 11). 문제가 보고되면 플랜 B로 제외 |

- 기기 언어를 따르고, 지원하지 않는 언어는 영어로 표시합니다. 해석은 `lib/l10n/locale_resolution.dart`가 맡습니다.
  - `no`(노르웨이어) → `nb`
  - 스크립트 없는 `zh-TW`·`zh-HK`·`zh-MO` → 번체(`zh_Hant`). `zh-CN`·`zh-SG`·`zh-Hans-*` → 간체(`zh`)
  - 기기 선호 목록의 2순위 언어도 봅니다(`[sw, de]` → `de`). 목록 전체가 미지원이거나 비어 있으면 `en`
  - `nn`·`yue` 같은 근연어는 매핑하지 않습니다(영어).
- 키가 빠지면 생성 단계에서 한국어 값으로 채웁니다. 단 `zh_Hant`는 `zh`를 상속하므로 키가 빠지면 간체가 조용히 나옵니다. `arb_test`가 키 집합 동일·간체와 40% 이상 차이로 막습니다.
- 날짜는 언어별 월·일 형식, 진행률은 언어별 퍼센트 형식입니다. 시간(`mm:ss`)과 가격(스토어 표시값)은 바꾸지 않습니다.
- 아랍어·히브리어는 오른쪽→왼쪽 레이아웃입니다. 숫자패드 1~9는 계산기 관례대로 왼쪽→오른쪽을 유지하고, 보드는 바뀌지 않습니다.
- 문구를 추가·수정하는 방법: `lib/l10n/app_ko.arb` 수정 → 나머지 ARB 수정(복수형 범주와 `{` 사이 공백 금지, 예: `one{`) → `flutter pub get`(생성물 갱신) → 생성물까지 커밋.
- **언어 추가 = ARB 1개 + iOS 3곳**(`Info.plist` `CFBundleLocalizations`·`InfoPlist.xcstrings`·`project.pbxproj` `knownRegions`). `ios_config_test`가 네 목록이 같은지 검사합니다(간체·번체의 Apple 코드는 `zh-Hans`·`zh-Hant`).
- **플랜 B(문제 언어 제외)**: `lib/l10n/app_xx.arb` 삭제 → `flutter pub get` → iOS 3곳에서 해당 언어 제거 → 생성물 diff 포함 커밋.
- 글자 잘림은 테스트(Ahem 폰트)로 판정할 수 없습니다. `layout_test`는 overflow 예외만 잡으며, **잘림 판정은 실폰트 수동 캡처가 유일한 수단**입니다(체크리스트 F6b).
- iOS ATT 문구는 `ios/Runner/InfoPlist.xcstrings`에 언어별로 있습니다. 홈 화면 이름은 모든 언어에서 `Sudoku`입니다(사용자 확인 7).
- Android 13 이상의 앱별 언어 설정(`localeConfig`)은 지원하지 않습니다. 기기 언어만 따릅니다.

## 빌드

```powershell
flutter pub get
git diff --exit-code -- lib/l10n        # 커밋된 생성물이 ARB와 같은지
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test

# 디버그 (샘플 동영상 전면광고, 테스트 App ID)
flutter build apk --debug

# 릴리스: 단위 ID는 ad_ids.dart 기본값을 쓴다
flutter build appbundle --release
# 테스트 기기 해시나 단위 ID를 덮어쓸 때만 (config/ads.example.json 복사, git 제외)
#   --dart-define-from-file=config/ads.release.json
```

- 릴리스 단위 ID는 `lib/services/ads/ad_ids.dart`의 기본값(`iosProd`/`androidProd`)을 씁니다. `--dart-define-from-file=config/ads.release.json`은 테스트 기기 해시(`ADMOB_TEST_DEVICES`)나 단위 ID(`ADMOB_INTERSTITIAL_IOS`/`_ANDROID`, 보상형 `ADMOB_REWARDED_IOS`/`_ANDROID`)를 덮어쓸 때만 씁니다. 단위 ID가 `^ca-app-pub-\d{16}/\d{10}$` 형식이 아니면 무시하고 기본값을 씁니다.
- iOS 빌드·업로드는 [맥북에서 할 순서](#맥북에서-할-순서)와 [App Store Connect 체크리스트](#app-store-connect-체크리스트)를 따릅니다.

- `android/key.properties`(git 제외)가 없으면 릴리스도 디버그 키로 서명되고 `key.properties 없음` 경고가 나옵니다(Play 업로드 불가). 템플릿은 `android/key.properties.example`입니다. 파일이 있는데 키가 빠졌으면 명확한 메시지로 실패합니다.
- 릴리스 AdMob App ID는 `android/app/build.gradle.kts`의 `prodAdmobAppId`(공개값, 커밋됨)입니다. 비어 있으면 테스트 App ID를 쓰고 `prodAdmobAppId 비어 있음` 경고를 남깁니다. `key.properties`로는 덮어쓰지 않습니다(빈 값이면 `MobileAdsInitProvider` 크래시).
- 릴리스 빌드에 광고 단위 ID가 비어 있으면 광고는 건너뜁니다(`skipped`).

## 광고 ID 위치

| 항목 | 값 | 디버그·프로필 위치 | 릴리스 위치 |
|---|---|---|---|
| Android App ID | `ca-app-pub-7432278320907197~1580424878` (2026-10-26 등록, 콘솔 텍스트 대조 일치) | `android/app/build.gradle.kts` `testAdmobAppId` | `android/app/build.gradle.kts` `prodAdmobAppId` |
| iOS App ID | `ca-app-pub-7432278320907197~4407658951` (2026-10-22 등록, 2026-10-22 콘솔 DOM 대조 일치) | `ios/Flutter/Debug.xcconfig` | `ios/Flutter/Release.xcconfig` `GAD_APPLICATION_ID` (Profile은 `[config=Profile]` 줄로 샘플 유지) |
| Android 전면 | `ca-app-pub-7432278320907197/4341485430` (2026-10-26 등록, 콘솔 텍스트 대조 일치) | `ad_ids.dart` `androidSample` | `ad_ids.dart` `androidProd` (dart-define `ADMOB_INTERSTITIAL_ANDROID`로 덮어쓰기) |
| iOS 전면 | `ca-app-pub-7432278320907197/4247876859` (2026-10-22 콘솔 DOM 대조 일치) | `ad_ids.dart` `iosSample` | `ad_ids.dart` `iosProd` (dart-define `ADMOB_INTERSTITIAL_IOS`로 덮어쓰기) |
| Android 보상형 | **미생성 (콘솔 작업 필요)**. 예정 이름 `sudoku_reward_android`, 보상 1개 `hint` | Google 샘플 `ca-app-pub-3940256099942544/5224354917` | `ad_ids.dart` `androidRewardedProd` (현재 `''`, dart-define `ADMOB_REWARDED_ANDROID`로 덮어쓰기) |
| iOS 보상형 | **미생성 (콘솔 작업 필요)**. 예정 이름 `sudoku_reward_ios`, 보상 1개 `hint` | Google 샘플 `ca-app-pub-3940256099942544/1712485313` | `ad_ids.dart` `iosRewardedProd` (현재 `''`, dart-define `ADMOB_REWARDED_IOS`로 덮어쓰기) |

- AdMob 콘솔(2026-10-22 등록): iOS 앱 `스도쿠`(스토어 미등록), 전면광고 단위 `sudoku_pregame_interstitial_ios`(광고 유형 동영상만). 게시자 ID `pub-7432278320907197`.
- 반영 완료(`Release.xcconfig`, `iosProd`). **skip 0건 게이트**(업로드 전): `ad_ids_test`, `legal_links_test`. `legal_links_test`는 방침 URL을 넣기 전까지 skip 1건이 정상이며, 업로드 전에는 0건이어야 합니다.
- 콘솔 재대조(2026-10-22, 페이지 텍스트): 앱 `스도쿠`(iOS, 1개, 중복 없음) App ID `ca-app-pub-7432278320907197~4407658951`, 단위 `sudoku_pregame_interstitial_ios`(전면 광고, 1개) 단위 ID `ca-app-pub-7432278320907197/4247876859`, 고급 설정 광고 유형 `동영상` → 코드와 모두 일치, 새로 만든 항목 없음.
- `app-ads.txt` 완성 줄(체크리스트 E4 도메인 루트에 게시): `google.com, pub-7432278320907197, DIRECT, f08c47fec0942fa0`
- AdMob 콘솔(2026-10-26 등록): Android 앱 `스도쿠`(스토어 미등록), 전면광고 단위 `sudoku_pregame_interstitial_android`(광고 유형 동영상만, 게재빈도 설정 사용중지됨). 반영 완료(`prodAdmobAppId`, `androidProd`), `ad_ids_test` 짝 불변식 통과. 입력란이 없어 `com.jang.sudoku`는 콘솔에 기록되지 않습니다(출시 후 스토어 연결 E3에서 맞춰짐).
- 보상형 단위(2026-10-29 기준 미생성): 체크리스트 E5 순서대로 먼저 두 앱의 단위 목록을 조회해 보상형이 있으면 재사용, 없으면 생성(서버 측 확인·게재빈도 설정 끔). 받은 ID를 `androidRewardedProd`/`iosRewardedProd`에 넣고 위 표의 "미생성" 칸을 ID·등록일·대조 방식으로 바꿉니다. 비어 있는 동안 릴리스 빌드의 보상형은 항상 `unavailable`이며, 무료 힌트와 광고 제거 경로는 정상 동작합니다.
- 광고 단위의 광고 유형을 동영상만으로 좁히면 필 레이트가 떨어질 수 있습니다(콘솔에서 되돌릴 수 있음). 동영상으로 설정해도 광고 길이는 보장되지 않습니다(위 표).

## 주간 대결·힌트·이어 도전

- **주간 대결**: ISO 주(경계 UTC 월 00:00 = KST 월 09:00) × 난이도 5개마다 고정 시드 퍼즐 1개. 보드 ID는 `<ISO 주>_<난이도>_g<kGeneratorVersion>`(예: `2026-W44_hard_g1`). 익명 uid별 최고 클리어 시간을 Firestore `weekly/{board}/entries/{uid}`에 저장하고, 주간 화면은 난이도별 1등 닉네임·시간을 보여 줍니다. 오프라인에서 클리어하면 대기열에 두었다가 재전송합니다.
- **공개 닉네임**: 2~12자, 기기에 저장, 언제든 수정. 서버에는 `nick`으로 들어가며 없으면 `''`(화면에는 "익명").
- **힌트**: 기기 날짜 기준 하루 3회 무료, 이후 1회당 보상형 광고 1편. 광고 제거 사용자는 무제한. 힌트를 쓴 판은 주간 순위와 기기의 최고 기록에서 제외됩니다.
- **이어 도전**: 실수 5회 후 보상형 광고를 보면(광고 제거 사용자는 즉시) 실수가 0으로 돌아가고 계속합니다.
- 보상형 광고는 모두 사용자가 버튼을 눌러 선택할 때만 나오며, 전면광고를 대체하지 않습니다.
- 패키지(해석된 버전): `firebase_core` 5.1.0, `firebase_auth` 7.0.1, `cloud_firestore` 7.1.0, `characters` 1.4.1.

### 시드 생성 실측표 [R]

주간 퍼즐은 시드로 기기에서 생성하므로 첫 생성 시간을 잽니다. `flutter test test/services/sudoku_generator_test.dart --reporter expanded`의 실측 출력입니다.

- 측정 환경: `flutter test`(JIT), 개발 PC Windows 11 Pro, AMD Ryzen 5 7600 6-Core, RAM 32GB, Flutter 3.47.7. 측정일 2026-10-29.
- 시드: 난이도별 5개(`2026-W40`~`2026-W44`). `kGeneratorVersion = 1`, `kUniqueCheckNodeCap = 20000`.

| 난이도 | 중앙값 ms | 최댓값 ms | 빈칸 수 | 합격(최댓값 ≤ 400ms) |
|---|---|---|---|---|
| 쉬움 | 0 | 10 (첫 실행 JIT 워밍업) | 38 | 통과 |
| 보통 | 0 | 0 | 45 | 통과 |
| 어려움 | 0 | 0 | 52 | 통과 |
| 전문가 | 1 | 3 | 56~58 | 통과 |
| 지옥 | 0 | 2 | 56~58 | 통과 |

- **합격선**: 개발 PC JIT 기준 난이도별 최댓값 ≤ 400ms. 중급 실기기가 약 4배 느리다고 보면 약 1.6초로, 기존 예산 1.5초와 비슷합니다. → **모두 통과**.
- **초과 시**: 먼저 `kUniqueCheckNodeCap`을 낮추고, 부족하면 `hell.targetHoles`를 조정합니다. 어느 쪽이든 `kGeneratorVersion`을 올리고(보드 ID의 `g` 값이 바뀜) 골든을 다시 고정한 뒤 다시 잽니다.
- **실기기 측정값**: 미측정. 체크리스트 F6b 40(중급 Android 실기기, release 빌드, 지옥 시드 첫 생성)에서 채웁니다.

| 기기 | 빌드 | 지옥 첫 생성 ms | 측정일 |
|---|---|---|---|
| (F6b 40에서 기록) | release | | |

## Firebase

주간 대결용입니다. **2026-10-29 기준 콘솔 작업 미완료**(이번 작업에서 Chrome이 연결되지 않아 조회·생성을 하지 못함). `lib/firebase_options.dart` 값이 `TODO`인 동안 `firebaseConfigured`가 false라 홈 주간 대결 카드와 설정 닉네임 행이 숨겨지고, 나머지 기능은 정상 동작합니다.

- 초기화는 Dart에서만 합니다(`lib/firebase_options.dart`). `google-services.json`·`GoogleService-Info.plist`는 **저장소에 넣지 않습니다**. 확인: `git status --porcelain | Select-String 'google-services|GoogleService-Info'` 출력 0.
- **apiKey는 공개값이며 키 제한은 사람이 한다.** Firebase apiKey는 앱에 평문으로 들어가는 식별용 값이고, 접근 통제는 보안 규칙(`firebase/firestore.rules`)이 합니다. Google Cloud 콘솔의 API 키 제한(Android 패키지명+SHA-1, iOS 번들 ID)은 사용자가 직접 합니다(체크리스트 H8).
- 보안 규칙 요약(`firebase/firestore.rules`): 로그인(익명)한 사용자만 읽기, 쓰기는 본인 uid 문서만, 갱신은 더 빠른 `ms`이거나 닉네임만 바꾸는 경우만, `hintUsed`는 false만, 삭제 불가. 필드는 `ms`(10초~24시간), `nick`(UTF-16 48 이하), `hintUsed`(false), `v`(1), `updatedAt`(서버 시각), `expireAt`(주 종료 + 56일, TTL용).
- 처리 데이터: 익명 UID, 클리어 시간, 공개 닉네임. Google이 IP를 처리할 수 있습니다([개인정보처리방침](docs/privacy-policy.md) §2).
- **Android Gradle 변경 2건 (Firebase 때문에 필요)**: `google-services` 플러그인은 여전히 쓰지 않습니다.
  - `android/settings.gradle.kts`: Kotlin 플러그인 2.2.20 → 2.3.20. `firebase_auth` 7.0.1이 가져오는 네이티브 `firebase-auth-25.0.0`이 Kotlin 메타데이터 2.4.0으로 컴파일돼 있어, 2.2.20에서는 `:firebase_auth:compileDebugKotlin`이 `Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 2.4.0, expected version is 2.2.0`으로 실패합니다.
  - `android/app/build.gradle.kts`: `kotlinOptions { jvmTarget }` → `kotlin { compilerOptions { jvmTarget.set(JvmTarget.JVM_17) } }`. Kotlin 2.3에서는 `Using 'jvmTarget: String' is an error`로 스크립트 컴파일이 실패합니다. JVM 17 타깃 값은 같습니다.
  - 확인(2026-10-29): 원래 설정으로 되돌리면 위 오류로 `flutter build apk --debug` 실패, 두 변경을 적용하면 `√ Built build\app\outputs\flutter-apk\app-debug.apk`.

### 남은 콘솔 작업 (체크리스트 H)

금지: 결제·요금제(Blaze 포함) 변경, 계정 권한 변경, 기존 항목 삭제·수정, API 키 제한(사람 몫).

1. 프로젝트 목록을 먼저 조회하고 있으면 재사용, 없으면 `sudoku-jang` 생성. Analytics 끔, **Spark 요금제 유지**.
2. 앱 2개 등록: Android·iOS `com.jang.sudoku`(SDK 안내 단계 건너뜀). 설정 파일은 새 빈 임시 폴더(`%TEMP%\sudoku-fb-<날짜>\`)에 받아 필요한 값(apiKey·appId·messagingSenderId·projectId)만 `lib/firebase_options.dart`에 넣고 폴더를 삭제.
3. Authentication > 익명 로그인 사용 설정.
4. Firestore 생성: `asia-northeast3`, 프로덕션 모드. 결제 연결을 요구하면 중단.
5. `firebase/firestore.rules`를 붙여넣고 게시(사용자 승인 시).
6. Rules Playground로 [firebase/rules_cases.md](firebase/rules_cases.md)의 10케이스 실행·기록.
7. (선택) 컬렉션 그룹 `entries`의 `expireAt`에 TTL. 요금제 변경을 요구하면 건너뜀. 설정 여부에 따라 개인정보처리방침 §4 보존 기간을 고침(현재 "삭제 요청 시까지").
8. 아래 결과 표를 채움.

| 항목 | 값 | 확인일·대조 방식 |
|---|---|---|
| 프로젝트 ID | 미설정 | |
| Android 앱 ID | 미설정 | |
| iOS 앱 ID | 미설정 | |
| 익명 인증 | 미설정 | |
| Firestore 리전 | 미설정 (예정 `asia-northeast3`) | |
| 규칙 게시 | 미게시 | |
| Playground 10케이스 | 미실행 | |
| TTL(`entries.expireAt`) | 미설정 | |
| API 키 제한(사람) | 미설정 | |

- 신고된 닉네임은 사람이 콘솔에서 지웁니다. 절차: 체크리스트 H11.

## 맥북에서 할 순서

```sh
flutter --version                      # 3.47.7 이어야 함(다르면 pbxproj 가 바뀜)
flutter pub get
flutter test test/platform              # pod install 전에 맥에서 한 번
cd ios && pod install --repo-update && cd ..    # Podfile.lock·project.pbxproj·Runner.xcworkspace/contents.xcworkspacedata 커밋(첫 pod install 이라 pbxproj 가 다시 쓰임)
grep -q url_launcher_ios ios/Podfile.lock
open -a Simulator && flutter run       # 샘플 전면광고·ATT 창 확인. 결제 버튼 비활성은 정상
open ios/Runner.xcworkspace            # Signing & Capabilities > Team 선택(1회)
flutter build ipa --release            # 실제 단위(송출 검증·심사용). 테스트 기기: --dart-define-from-file=config/ads.release.json
# 내부 흐름 검증용 샘플 단위 빌드(TestFlight 내부 그룹 전용, 심사에 선택하지 않음)
#   flutter build ipa --dart-define=ADMOB_INTERSTITIAL_IOS=ca-app-pub-3940256099942544/5135589807
# 업로드 전 게이트: 심사용 빌드에서는 ADMOB_INTERSTITIAL_IOS 가 출력되면 안 됨
for d in $(grep '^DART_DEFINES=' ios/Flutter/Generated.xcconfig | cut -d= -f2- | tr ',' ' '); do echo "$d" | base64 -D; echo; done
xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release | grep GAD_APPLICATION_ID
xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner -configuration Profile | grep GAD_APPLICATION_ID
grep -q "privacyPolicyUrl = 'https://" lib/services/legal_links.dart   # 업로드 전 게이트
# 지역화 확인: .lproj 34개(Base 포함), ko 는 한국어 ATT 문구. 빠졌으면 Xcode 에서 InfoPlist.xcstrings 를 Runner 타깃에 다시 추가
ls -d build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app/*.lproj | wc -l   # 34 (Base 포함)
ls build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app/{zh-Hans,zh-Hant,ar,ko}.lproj/InfoPlist.strings
plutil -p build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app/ko.lproj/InfoPlist.strings
open build/ios/archive/Runner.xcarchive   # Organizer > Distribute App > App Store Connect (업로드만)
```

- 기대값: Release는 실제 App ID(`~4407658951`), Profile은 `~1458002511`입니다.
- **Firebase pod 게이트**: 첫 `pod install`은 Firebase pod(`firebase_core`·`firebase_auth`·`cloud_firestore`)를 포함하므로 오래 걸립니다. `pod install`과 첫 `flutter build ipa` 소요 시간을 체크리스트 F5에 기록합니다. `GoogleService-Info.plist`는 Xcode에 추가하지 않습니다(Dart 초기화).
- **샘플 단위 빌드는 흐름 검증, 실제 단위 빌드는 송출 검증**입니다. 샘플 빌드는 TestFlight 내부 그룹에만 배포하고 심사 제출 빌드로 선택하지 않습니다. 심사 제출 빌드는 TestFlight 빌드보다 `+N`이 커야 하며, 같은 번호로 다시 업로드하지 않습니다.
- 실기기에서 실제 단위 빌드를 처음 실행할 때:
  1. **새 게임을 시작하지 않습니다**(광고 노출 없음).
  2. Xcode 콘솔에 찍힌 `testDeviceIdentifiers` 해시를 `config/ads.release.json`의 `ADMOB_TEST_DEVICES`에 넣습니다.
  3. 다시 빌드한 뒤 광고에 "테스트 광고" 표시가 나오는지 확인하고 나서 진행합니다(체크리스트 D4).
- 버전은 `pubspec.yaml` 한 곳에서만 관리합니다(현재 `2.0.0+3`). 업로드할 때마다 `+N`을 올리고 `--build-number`는 쓰지 않습니다.
- 업로드는 Xcode Organizer의 "Distribute App"으로 합니다(altool 미사용).
- (선택) 시뮬레이터에서 결제를 확인하려면 Xcode에서 `File > New > StoreKit Configuration File`로 `remove_ads`(Non-Consumable)를 만들고 Scheme > Run > StoreKit Configuration에 지정한 뒤 **Xcode ▶로 실행**합니다. `flutter run`에는 적용되지 않습니다. TestFlight는 이 설정을 무시합니다.
- iOS 시뮬레이터는 실제 광고를 받지 않습니다. 실기기 릴리스 테스트는 테스트 기기를 등록(체크리스트 D4)한 뒤에만 하고, 광고는 클릭하지 않습니다.
- **ATT 채널(`ios/Runner/AppDelegate.swift`, C4 커밋)은 Windows에서 컴파일하지 못했습니다.** 맥에서 빌드가 실패하면 AppDelegate의 ATT 채널 블록(`if let r = … registrar(forPlugin: "SudokuAtt")` 18~23행)만 삭제하고, 창 옵저버(10~13행)와 implicit engine 등록은 유지합니다. UMP 동의 폼과 개인정보 옵션 폼이 창 옵저버가 연결한 `delegate.window`에 의존하므로 `git revert <C4>`로 통째로 되돌리면 EEA 동의 폼이 뜨지 않습니다. 이 경우 UMP IDFA 메시지 게시(체크리스트 D3)가 필수입니다.

## App Store Connect 체크리스트

원본은 [출시 체크리스트 F 블록](docs/release-checklist.md#f-app-store-맥북-로컬--이후-ci)입니다.

1. 앱 생성(번들 `io.minbuild.sudoku`, 기본 언어 English(U.S.), 한국어 현지화 추가, 이름 `Sudoku JANG`)
2. 유료 앱 계약
3. `remove_ads` 비소모성 상품: USD $0.49 → 확인한 KRW 표시값을 README 가격표에 기록
4. App Privacy(기기 ID·광고 데이터, 추적=예, Organizer Privacy Report 참고. 주간 대결: 사용자 ID·기타 사용자 콘텐츠·게임 플레이 콘텐츠 = 앱 기능, [스토어 등록정보](docs/store-listing.md)) + 개인정보처리방침 URL: 영어 https://minbuild.github.io/sudoku/en/privacy.html, 한국어 https://minbuild.github.io/sudoku/privacy.html
5. 연령 등급
6. 6.9″ iPhone 스크린샷 + 마케팅 URL https://minbuild.github.io/sudoku/ · 지원 URL https://minbuild.github.io/sudoku/support.html (영어는 `/sudoku/en/`)
7. TestFlight 실기기에서 ATT 창, 샌드박스 구매·복원, "복원할 구매가 없어요" 확인 + F6b QA 표 기록
8. 버전 페이지 "앱 내 구입"에 `remove_ads` 첨부(심사용 스크린샷 포함, 빠지면 반려)
9. 심사 메모(**영어 병기**, 문안은 체크리스트 F8):
   - 한국어: "새 게임 시작 시 전면광고(첫 판부터, 이후 15분 간격), 광고 제거는 비소모성 IAP, 설정 > 구매 복원. 개인정보처리방침은 설정 > 개인정보처리방침. ATT 창은 첫 실행 시 홈 화면이 뜬 직후 표시됩니다. 설정 > 개인정보 보호 및 보안 > 추적 > '앱이 추적을 요청하도록 허용'이 꺼져 있으면 iOS가 창을 띄우지 않습니다. 보상형 광고는 이용자가 버튼을 눌렀을 때만 표시되며(무료 힌트 하루 3회 이후의 힌트, 실수 5회 후 이어 도전), 전면광고를 대체하지 않습니다. 광고 제거 구매자는 힌트 무제한, 이어 도전 즉시. 주간 대결은 Firebase 익명 인증을 쓰며 계정이 필요 없습니다. 닉네임은 이용자가 정하며, 주간 대결 화면의 '부적절한 닉네임 신고'(이메일)로 신고하면 개발자가 삭제합니다."
   - English: "An interstitial ad is shown when starting a new game (from the first game, then at most once every 15 minutes). Remove Ads is a non-consumable IAP; Settings > Restore Purchases. Privacy policy: Settings > Privacy Policy. The ATT prompt appears right after the home screen on first launch. iOS does not show it if Settings > Privacy & Security > Tracking > 'Allow Apps to Request to Track' is off. Rewarded ads are shown only when the user taps a button (a hint after the 3 free daily hints, or continuing after 5 mistakes); they do not replace interstitials. Remove Ads purchasers get unlimited hints and continue without an ad. The weekly challenge uses Firebase Anonymous Authentication; no account is needed. Nicknames are chosen by users; objectionable nicknames can be reported via 'Report a nickname' (email) on the weekly challenge screen and are removed by the developer."
10. 제출(사용자)

## 출시 전 체크리스트

- [출시 체크리스트](docs/release-checklist.md) (원본, 사용자가 바로 할 작업 5개 포함)
- [개인정보처리방침 초안](docs/privacy-policy.md)
- [스토어 등록정보 초안](docs/store-listing.md)

## 알려진 한계

- 광고 길이를 보장하지 않습니다(위 표 참고).
- 노필·오프라인·동의 거부일 때는 광고 없이 시작합니다.
- Android는 2026-10-26, iOS는 2026-10-22 AdMob에 등록했습니다. 두 앱 모두 스토어 연결(E3) 전에는 송출이 제한될 수 있습니다.
- UMP 동의 갱신이 10초 안에 응답하지 않으면 동의 폼을 생략하고 ATT로 진행합니다. 이 경우 ATT 창이 게임 중에 뜰 수 있으며, 창이 떠 있는 동안 게임은 일시정지됩니다.
- 신규 광고 단위는 최대 약 1시간 동안, 스토어에 연결되기 전에는 송출이 제한될 수 있습니다. 이때 no-fill(code 3)이 나면 약 3초 뒤 광고 없이 게임이 시작되는데, 이것이 정상입니다.
- `_init ??=`가 초기화 실패를 세션 동안 기억합니다. 그래서 오프라인으로 앱을 처음 열면 그 세션에서는 광고가 나오지 않습니다. 2차 이월 설계: `_init ??=` 재시도는 warmUp(앱 시작·복귀)에서만 하고, 새 게임 직전 경로에서는 재시도하지 않습니다(UMP/ATT 순서 유지).
- 생성기는 유일해를 유지하며 한 번만 훑기 때문에 목표 빈칸 수에 못 미칠 수 있습니다. 측정치(난이도별 30판, Windows 개발 PC):

  | 난이도 | 목표 | 최소 수용 | 평균 | 최소~최대 |
  |---|---|---|---|---|
  | 쉬움 | 38 | 38 | 38.0 | 38~38 |
  | 보통 | 45 | 45 | 45.0 | 45~45 |
  | 어려움 | 52 | 48 | 52.0 | 52~52 |
  | 전문가 | 58 | 50 | 56.6 | 54~58 |
  | 지옥 | 62 | 50 | 56.4 | 55~58 |

  **지옥과 전문가의 실제 빈칸 차이는 거의 없습니다.**

**주간 대결·힌트**

- App Check가 없어 개조 클라이언트, 시계 조작, 외부 풀이, 판 암기를 막지 못합니다(규칙은 형식·본인 문서·더 빠른 기록만 검사).
- 즉시 체크 ON과 OFF 판이 같은 순위표를 씁니다.
- 일일 힌트는 기기 시계를 기준으로 합니다(시계를 바꾸면 무료 횟수가 다시 찰 수 있음).
- 신고된 닉네임은 사람이 콘솔에서 지웁니다. 절차는 [체크리스트 H11](docs/release-checklist.md#h-firebase주간-대결).
- Android는 재설치하면 새 익명 uid가 되어 이전 주간 기록과 이어지지 않습니다. iOS는 Keychain 때문에 같은 uid일 수 있습니다.
- 보상형 광고를 끝까지 봤는데 그 사이 게임 화면이 닫히면(드묾) 보상이 사라집니다.
- 2026-10-29 기준 보상형 단위와 Firebase가 콘솔에 없어, 릴리스 빌드에서는 보상형이 항상 사용 불가이고 주간 대결이 숨겨집니다(§[Firebase](#firebase)).

### 사람이 할 일

- 광고 길이는 앱이 정할 수 없습니다. AdMob 콘솔 > 앱 `스도쿠` > 광고 단위 `sudoku_pregame_interstitial_ios` > 고급 설정 확인 결과(2026-10-22): 광고 유형 `동영상`, 동영상 길이·건너뛰기 관련 옵션 없음(고급 설정 항목은 광고 유형·게재빈도 설정·최소 eCPM뿐), 게재빈도 설정 `사용중지됨`.
- 짧은 광고를 원하면 광고 유형에서 '동영상만'을 해제하고 텍스트·이미지·리치 미디어를 허용할지 결정합니다(몇 초 뒤 닫힘, 필 레이트 상승, 앱 업데이트 불필요).
- 콘솔 빈도 제한(Frequency capping)은 설정하지 않습니다. 앱은 광고 직후 다음 광고를 미리 받아 두므로, 제한이 걸리면 15분 뒤 판에서 광고가 빠집니다.
- 첫 실행 직후 ATT 창이 뜨기 전에 새 게임을 누르면 첫 판 광고가 생략될 수 있으며, 다음 새 게임에서 나옵니다.
- 번역 검수: en·ko 필수. ko·en의 ATT·개인정보 옵션·개인정보처리방침 같은 법적 문구는 검수 전 출시 금지. 나머지 31개 언어는 미검수 출시(사용자 확인 11).
- 스토어 등록정보 번역(App Store Connect·Play): 기본 언어 **English(U.S.)**, **한국어 현지화 필수**, 그 밖의 언어는 권장(사람이 번역, G4). 언어별 스크린샷 포함.
- AdMob UMP 메시지(GDPR·IDFA)의 언어에 앱 지원 33개 언어(§지원 언어)와 EEA 지역 언어를 추가. 추가한 뒤 사용자가 메시지를 **게시**해야 반영됩니다.
- 개인정보처리방침 영어본 작성·호스팅(UMP GDPR 메시지가 링크함). App Store Connect에는 언어별 방침 URL 입력(같은 URL도 가능).
- AdMob 보상형 단위 생성(E5), Firebase 콘솔 설정(H1~H7), API 키 제한(H8), `supportEmail` 결정(H10). 개인정보처리방침의 국외 이전 고지는 법률 검토가 필요합니다.
