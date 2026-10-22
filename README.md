# Sudoku JANG 2.0

Flutter 스도쿠 앱. Android 먼저 출시하고, iOS는 코드와 설정을 반영했습니다(빌드 검증은 맥북: [맥북에서 할 순서](#맥북에서-할-순서)).

- 패키지명 `sudoku`, Android `com.jang.sudoku`, 버전 `2.0.0+3`
- 확인한 Flutter 버전: 3.47.7 (Dart 3.13.5)

## 사용자 요구 대비 동작

| 사용자 요구 | 실제 구현 | 요구와 다른 점 (사용자에게 반드시 고지) |
|---|---|---|
| "디자인부터 새로, 훨씬 깔끔하게" | 디자인 토큰(`ThemeExtension`)과 `CustomPainter` 한 장으로 그리는 보드로 라이트 테마를 새로 구성 | 다크 테마는 이번 범위가 아닙니다. 토큰 구조만 미리 만들어 둡니다. |
| "게임 시작할 때 10초 정도 광고 한 편" | 앱 실행 후 **첫 새 게임부터** AdMob 전면광고를 1회 보여 줍니다. 이후에는 마지막 노출 시각부터 **15분**(`AdSchedule.defaultInterval`)이 지난 뒤 시작하는 새 게임에만 보여 줍니다. 판 수가 아니라 시간 기준입니다(쉬움은 빨리 끝나기 때문). 판단은 새 게임을 시작하는 시점에만 하고, 게임 중에는 광고가 뜨지 않습니다. 시각은 메모리에만 두므로 앱을 다시 실행하면 첫 판부터 다시 나옵니다. 광고를 못 띄운 경우(no-fill, 오프라인, 취소)는 기록하지 않아 다음 새 게임에서 다시 시도합니다. 이어하기, 같은 퍼즐 다시, 재시작은 대상이 아닙니다. | **광고 길이는 앱이 정할 수 없습니다.** 광고 네트워크가 소재를 고르기 때문에 보통 5~30초이고, 동영상은 5초 뒤 건너뛰기가 될 수 있으며, 정적 이미지 광고가 나오면 1~2초 만에 닫힐 수도 있습니다. 광고를 받지 못하면(오프라인, 노필, 동의 거부) **광고 없이 최대 약 3초 뒤 게임이 시작됩니다.** 시청을 강제할 수 있는 보상형(Rewarded) 광고는 정책상 "사용자가 선택해 보는 광고"여야 해서 쓸 수 없습니다. 광고를 10초 동안 붙잡아 두는 인위적 대기도 정책 위반 위험이 있어 넣지 않습니다. |
| "평생 광고 제거 990원(끝자리 내림 가격)" | 비소모성 상품 `remove_ads` 1개를 둡니다. 가격은 **스토어 콘솔에서** 설정하고, 앱은 스토어가 돌려주는 `ProductDetails.price`만 표시합니다. | **Google Play**: ₩990으로 바로 설정할 수 있습니다. **App Store**: Apple의 KRW 가격 목록에 ₩990이 있으면 ₩990, 없으면 **₩990 이하 가격 중 가장 높은 값**으로 정합니다. 이 경우 ₩990과 달라지므로 사용자 확인이 필요합니다. 해외 가격은 각 콘솔이 자동 환산합니다(USD 기준가 $0.99). 확정한 가격은 README §가격표에 기록합니다. 가격 정책: 끝자리 내림(기준 ₩1,000 → ₩990). |

### 사용자 확인이 필요한 변경

1. 이어하기 기능 추가 (자동 저장 1슬롯)
2. "숫자 먼저 선택" 입력 방식 삭제 → "칸 선택 → 숫자 입력"으로 통일
3. 실수 5회면 게임 오버 (기존 규칙 유지, undo로 실수 횟수가 줄지 않음)
4. App Store 최종 가격
5. 광고 길이 미보장
6. iPhone 전용 출시(iPad 제외). 한 번 iPad 지원으로 출시하면 이후 iPad를 뺄 수 없으므로, App Store Connect에 iPad를 지원한 기존 기록이 있으면 `TARGETED_DEVICE_FAMILY`를 `"1,2"`로 되돌립니다.
7. iOS 홈 화면 이름을 `Sudoku` 그대로 둘지 `스도쿠`로 바꿀지(AdMob 앱 이름은 `스도쿠`, Android 라벨은 `sudoku JANG`)
   - 이름 불일치(AdMob `스도쿠` / iOS 홈 `Sudoku` / 스토어 `Sudoku JANG` / Android `sudoku JANG`)는 의도된 상태입니다. AdMob 앱 이름을 바꿔도 App ID는 바뀌지 않습니다.
8. App Store 가격이 ₩990이 아닐 수 있음(4번과 연결)
9. 광고 노출 정책: 첫 판부터, 15분 간격
10. 광고 제거 가격: **현재 결정 미정**(IAP 상품 미등록). 권장가 1회 구매 ₩1,900(메모), 이전 결정 ₩990. 콘솔 등록 전에 확정

**현재 결정**: 미정(IAP 상품 미등록). 권장 가격(2026-10-22 메모): 1회 구매 **₩1,900**. App Store는 KRW 가격 목록에 ₩1,900이 있는지 확인이 필요하고, 없으면 사용자 확인 대상입니다. 확정 전까지 콘솔 상품 등록(C3·F3)은 보류합니다.

(이전 결정, 확정 아님) **가격 정책(끝자리 내림)**: 기준가 ₩1,000에서 끝자리를 내려 ₩990. Play는 ₩990을 그대로 입력합니다. App Store는 KRW 가격 목록에 ₩990이 있으면 그 값을, 없으면 ₩990 이하에서 가장 높은 가격을 쓰며, 이 경우 사용자 확인이 필요합니다. 해외 가격은 USD $0.99를 기준으로 콘솔이 자동 환산합니다. 앱 코드에는 가격 숫자를 넣지 않고 `ProductDetails.price`만 표시합니다.

## 가격표

아래 ₩990 값은 이전 결정입니다. 현재는 미정이며 권장가는 ₩1,900입니다(위 메모).

| 스토어 | 상품 ID | 설정 가격 | 확인일 | 앱 표시값(`ProductDetails.price`) |
|---|---|---|---|---|
| Play | `remove_ads` | ₩990 | | |
| App Store | `remove_ads` | ₩990 또는 그 이하 최고가 | | |

빈칸은 콘솔에 등록하고 QA를 마친 뒤 채웁니다. 가격 검증은 logcat의 `IAP price=… raw=… cur=KRW` 로그로 합니다.

## 지원 언어

| 언어 | 코드 | 번역 상태 | 출시 게이트 |
|---|---|---|---|
| 한국어(템플릿) | ko | 원문 | 검수 필수 |
| 영어(폴백) | en | AI 초벌 | 검수 필수 |
| 프랑스어·스페인어·일본어·포르투갈어(브라질식) | fr·es·ja·pt | AI 초벌 | 검수하거나, 미완이면 플랜 B로 제외 |

- 기기 언어를 따르고, 지원하지 않는 언어는 영어로 표시합니다. 키가 빠지면 생성 단계에서 한국어 값으로 채웁니다.
- 날짜는 언어별 월·일 형식, 진행률은 언어별 퍼센트 형식입니다. 시간(`mm:ss`)과 가격(스토어 표시값)은 바꾸지 않습니다.
- 문구를 추가·수정하는 방법: `lib/l10n/app_ko.arb` 수정 → 나머지 5개 ARB 수정 → `flutter pub get`(생성물 갱신) → 생성물까지 커밋.
- **플랜 B(검수 미완 언어 제외)**: `lib/l10n/app_xx.arb` 삭제 → `flutter pub get` → Info.plist `CFBundleLocalizations`와 `ios/Runner/InfoPlist.xcstrings`에서 해당 언어 제거 → 생성물 diff 포함 커밋. `ios_config_test`가 ARB와 plist 언어 목록이 같은지 검사합니다.
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

- 릴리스 단위 ID는 `lib/services/ads/ad_ids.dart`의 기본값(`iosProd`/`androidProd`)을 씁니다. `--dart-define-from-file=config/ads.release.json`은 테스트 기기 해시(`ADMOB_TEST_DEVICES`)나 단위 ID(`ADMOB_INTERSTITIAL_IOS`/`_ANDROID`)를 덮어쓸 때만 씁니다. 단위 ID가 `^ca-app-pub-\d{16}/\d{10}$` 형식이 아니면 무시하고 기본값을 씁니다.
- iOS 빌드·업로드는 [맥북에서 할 순서](#맥북에서-할-순서)와 [App Store Connect 체크리스트](#app-store-connect-체크리스트)를 따릅니다.

- `android/key.properties`(git 제외)가 없으면 릴리스도 디버그 키로 서명되고 `key.properties 없음` 경고가 나옵니다(Play 업로드 불가). 템플릿은 `android/key.properties.example`입니다. 파일이 있는데 키가 빠졌으면 명확한 메시지로 실패합니다.
- 실제 AdMob App ID는 `android/key.properties`의 `admobAppId`에 넣습니다. 없으면 테스트 App ID를 쓰고 경고를 남깁니다.
- 릴리스 빌드에 광고 단위 ID가 비어 있으면 광고는 건너뜁니다(`skipped`).

## 광고 ID 위치

| 항목 | 값 | 디버그·프로필 위치 | 릴리스 위치 |
|---|---|---|---|
| Android App ID | 미등록, 테스트 ID | `android/app/build.gradle.kts` `testAdmobAppId` | `android/key.properties` `admobAppId` (없으면 테스트 ID) |
| iOS App ID | `ca-app-pub-7432278320907197~4407658951` (2026-10-22 등록, 2026-10-22 콘솔 DOM 대조 일치) | `ios/Flutter/Debug.xcconfig` | `ios/Flutter/Release.xcconfig` `GAD_APPLICATION_ID` (Profile은 `[config=Profile]` 줄로 샘플 유지) |
| Android 전면 | 미등록, `androidProd=''` | `ad_ids.dart` `androidSample` | `ad_ids.dart` `androidProd` (dart-define `ADMOB_INTERSTITIAL_ANDROID`로 덮어쓰기) |
| iOS 전면 | `ca-app-pub-7432278320907197/4247876859` (2026-10-22 콘솔 DOM 대조 일치) | `ad_ids.dart` `iosSample` | `ad_ids.dart` `iosProd` (dart-define `ADMOB_INTERSTITIAL_IOS`로 덮어쓰기) |

- AdMob 콘솔(2026-10-22 등록): iOS 앱 `스도쿠`(스토어 미등록), 전면광고 단위 `sudoku_pregame_interstitial_ios`(광고 유형 동영상만). 게시자 ID `pub-7432278320907197`.
- 반영 완료(`Release.xcconfig`, `iosProd`), `ad_ids_test` skip 0.
- 콘솔 재대조(2026-10-22, 페이지 텍스트): 앱 `스도쿠`(iOS, 1개, 중복 없음) App ID `ca-app-pub-7432278320907197~4407658951`, 단위 `sudoku_pregame_interstitial_ios`(전면 광고, 1개) 단위 ID `ca-app-pub-7432278320907197/4247876859`, 고급 설정 광고 유형 `동영상` → 코드와 모두 일치, 새로 만든 항목 없음.
- `app-ads.txt` 완성 줄(체크리스트 E4 도메인 루트에 게시): `google.com, pub-7432278320907197, DIRECT, f08c47fec0942fa0`
- 미등록 앱에는 번들 ID 입력란이 없어 `com.jang.sudoku`는 콘솔에 기록되지 않습니다(출시 후 스토어 연결 E3에서 맞춰짐).
- 광고 단위의 광고 유형을 동영상만으로 좁히면 필 레이트가 떨어질 수 있습니다(콘솔에서 되돌릴 수 있음). 동영상으로 설정해도 광고 길이는 보장되지 않습니다(위 표).

## 맥북에서 할 순서

```sh
flutter --version                      # 3.47.7 이어야 함(다르면 pbxproj 가 바뀜)
flutter pub get
cd ios && pod install --repo-update && cd ..    # Podfile.lock 커밋
open -a Simulator && flutter run       # 샘플 전면광고·ATT 창 확인. 결제 버튼 비활성은 정상
open ios/Runner.xcworkspace            # Signing & Capabilities > Team 선택(1회)
flutter build ipa --release            # 실제 단위(송출 검증·심사용). 테스트 기기: --dart-define-from-file=config/ads.release.json
# 내부 흐름 검증용 샘플 단위 빌드(TestFlight 내부 그룹 전용, 심사에 선택하지 않음)
#   flutter build ipa --dart-define=ADMOB_INTERSTITIAL_IOS=ca-app-pub-3940256099942544/5135589807
# 업로드 전 게이트: 심사용 빌드에서는 ADMOB_INTERSTITIAL_IOS 가 출력되면 안 됨
for d in $(grep '^DART_DEFINES=' ios/Flutter/Generated.xcconfig | cut -d= -f2- | tr ',' ' '); do echo "$d" | base64 -D; echo; done
xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release | grep GAD_APPLICATION_ID
xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner -configuration Profile | grep GAD_APPLICATION_ID
# 지역화 확인: .lproj 6개, ko 는 한국어 ATT 문구. 빠졌으면 Xcode 에서 InfoPlist.xcstrings 를 Runner 타깃에 다시 추가
ls -d build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app/{en,ko,fr,es,ja,pt}.lproj/InfoPlist.strings
plutil -p build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app/ko.lproj/InfoPlist.strings
open build/ios/archive/Runner.xcarchive   # Organizer > Distribute App > App Store Connect (업로드만)
```

- 기대값: Release는 실제 App ID(`~4407658951`), Profile은 `~1458002511`입니다.
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

1. 앱 생성(번들 `com.jang.sudoku`, 기본 언어 한국어, 이름 `Sudoku JANG`)
2. 유료 앱 계약
3. `remove_ads` 비소모성 상품: ₩990, 없으면 ₩990 이하 최고가(사용자 확인) → README 가격표에 기록
4. App Privacy(기기 ID·광고 데이터, 추적=예, Organizer Privacy Report 참고) + 개인정보처리방침 URL(`TODO_` 0건)
5. 연령 등급
6. 6.9″ iPhone 스크린샷 + 마케팅 URL·지원 URL을 E4 도메인 루트로 설정(F4b)
7. TestFlight 실기기에서 ATT 창, 샌드박스 구매·복원, "복원할 구매가 없어요" 확인 + F6b QA 표 기록
8. 버전 페이지 "앱 내 구입"에 `remove_ads` 첨부(심사용 스크린샷 포함, 빠지면 반려)
9. 심사 메모: "새 게임 시작 시 전면광고(첫 판부터, 이후 15분 간격), 광고 제거는 비소모성 IAP, 설정 > 구매 복원. ATT 창은 첫 실행 시 홈 화면이 뜬 직후 표시됩니다. 설정 > 개인정보 보호 및 보안 > 추적 > '앱이 추적을 요청하도록 허용'이 꺼져 있으면 iOS가 창을 띄우지 않습니다."
10. 제출(사용자)

## 출시 전 체크리스트

- [출시 체크리스트](docs/release-checklist.md) (원본, 사용자가 바로 할 작업 5개 포함)
- [개인정보처리방침 초안](docs/privacy-policy.md)
- [스토어 등록정보 초안](docs/store-listing.md)

## 알려진 한계

- 광고 길이를 보장하지 않습니다(위 표 참고).
- 노필·오프라인·동의 거부일 때는 광고 없이 시작합니다.
- **Android**는 AdMob 미등록(릴리스 광고 `skipped`, 체크리스트 E1-Android). iOS는 2026-10-22 등록했으며, 스토어 연결(E3) 전에는 송출이 제한될 수 있습니다.
- UMP 동의 갱신이 10초 안에 응답하지 않으면 동의 폼을 생략하고 ATT로 진행합니다. 이 경우 ATT 창이 게임 중에 뜰 수 있으며, 창이 떠 있는 동안 게임은 일시정지됩니다.
- 신규 광고 단위는 최대 약 1시간 동안, 스토어에 연결되기 전에는 송출이 제한될 수 있습니다. 이때 no-fill(code 3)이 나면 약 3초 뒤 광고 없이 게임이 시작되는데, 이것이 정상입니다.
- `_init ??=`가 초기화 실패를 세션 동안 기억합니다. 그래서 오프라인으로 앱을 처음 열면 그 세션에서는 광고가 나오지 않습니다(2차에서 수정).
- 생성기는 유일해를 유지하며 한 번만 훑기 때문에 목표 빈칸 수에 못 미칠 수 있습니다. 측정치(난이도별 30판, Windows 개발 PC):

  | 난이도 | 목표 | 최소 수용 | 평균 | 최소~최대 |
  |---|---|---|---|---|
  | 쉬움 | 38 | 38 | 38.0 | 38~38 |
  | 보통 | 45 | 45 | 45.0 | 45~45 |
  | 어려움 | 52 | 48 | 52.0 | 52~52 |
  | 전문가 | 58 | 50 | 56.6 | 54~58 |
  | 지옥 | 62 | 50 | 56.4 | 55~58 |

  **지옥과 전문가의 실제 빈칸 차이는 거의 없습니다.**

### 사람이 할 일

- 광고 길이는 앱이 정할 수 없습니다. AdMob 콘솔 > 앱 `스도쿠` > 광고 단위 `sudoku_pregame_interstitial_ios` > 고급 설정 확인 결과(2026-10-22): 광고 유형 `동영상`, 동영상 길이·건너뛰기 관련 옵션 없음(고급 설정 항목은 광고 유형·게재빈도 설정·최소 eCPM뿐), 게재빈도 설정 `사용중지됨`.
- 짧은 광고를 원하면 광고 유형에서 '동영상만'을 해제하고 텍스트·이미지·리치 미디어를 허용할지 결정합니다(몇 초 뒤 닫힘, 필 레이트 상승, 앱 업데이트 불필요).
- 콘솔 빈도 제한(Frequency capping)은 설정하지 않습니다. 앱은 광고 직후 다음 광고를 미리 받아 두므로, 제한이 걸리면 15분 뒤 판에서 광고가 빠집니다.
- 첫 실행 직후 ATT 창이 뜨기 전에 새 게임을 누르면 첫 판 광고가 생략될 수 있으며, 다음 새 게임에서 나옵니다.
- 번역 검수: en·ko 필수. ATT·개인정보 옵션·개인정보처리방침 같은 법적 문구는 검수 전 출시 금지.
- 스토어 등록정보 번역(App Store Connect·Play): 기본 언어가 한국어라서 **영어 등록정보는 출시 필수**, 나머지 4개 언어는 권장. 언어별 스크린샷 포함.
- AdMob UMP 메시지(GDPR·IDFA)의 언어에 앱 지원 6개 언어와 EEA 지역 언어를 추가.
- 개인정보처리방침 영어본 작성·호스팅(UMP GDPR 메시지가 링크함). App Store Connect에는 언어별 방침 URL 입력(같은 URL도 가능).
