# Sudoku JANG 2.0

Flutter 스도쿠 앱. Android 먼저 출시하고, iOS는 코드와 설정을 반영했습니다(빌드 검증은 맥북: [맥북에서 할 순서](#맥북에서-할-순서)).

- 패키지명 `sudoku`, Android `com.jang.sudoku`, 버전 `2.0.0+3`
- 확인한 Flutter 버전: 3.47.7 (Dart 3.13.5)

## 사용자 요구 대비 동작

| 사용자 요구 | 실제 구현 | 요구와 다른 점 (사용자에게 반드시 고지) |
|---|---|---|
| "디자인부터 새로, 훨씬 깔끔하게" | 디자인 토큰(`ThemeExtension`)과 `CustomPainter` 한 장으로 그리는 보드로 라이트 테마를 새로 구성 | 다크 테마는 이번 범위가 아닙니다. 토큰 구조만 미리 만들어 둡니다. |
| "게임 시작할 때 10초 정도 광고 한 편" | 새 퍼즐을 시작하기 직전에 AdMob **전면광고**(Interstitial)를 1회 보여 줍니다. AdMob 콘솔에서 광고 단위를 **동영상 위주**로 설정합니다. | **광고 길이는 앱이 정할 수 없습니다.** 광고 네트워크가 소재를 고르기 때문에 보통 5~30초이고, 동영상은 5초 뒤 건너뛰기가 될 수 있으며, 정적 이미지 광고가 나오면 1~2초 만에 닫힐 수도 있습니다. 광고를 받지 못하면(오프라인, 노필, 동의 거부) **광고 없이 최대 약 3초 뒤 게임이 시작됩니다.** 시청을 강제할 수 있는 보상형(Rewarded) 광고는 정책상 "사용자가 선택해 보는 광고"여야 해서 쓸 수 없습니다. 광고를 10초 동안 붙잡아 두는 인위적 대기도 정책 위반 위험이 있어 넣지 않습니다. |
| "평생 광고 제거 990원(끝자리 내림 가격)" | 비소모성 상품 `remove_ads` 1개를 둡니다. 가격은 **스토어 콘솔에서** 설정하고, 앱은 스토어가 돌려주는 `ProductDetails.price`만 표시합니다. | **Google Play**: ₩990으로 바로 설정할 수 있습니다. **App Store**: Apple의 KRW 가격 목록에 ₩990이 있으면 ₩990, 없으면 **₩990 이하 가격 중 가장 높은 값**으로 정합니다. 이 경우 ₩990과 달라지므로 사용자 확인이 필요합니다. 해외 가격은 각 콘솔이 자동 환산합니다(USD 기준가 $0.99). 확정한 가격은 README §가격표에 기록합니다. 가격 정책: 끝자리 내림(기준 ₩1,000 → ₩990). |

### 사용자 확인이 필요한 변경

1. 이어하기 기능 추가 (자동 저장 1슬롯)
2. "숫자 먼저 선택" 입력 방식 삭제 → "칸 선택 → 숫자 입력"으로 통일
3. 실수 5회면 게임 오버 (기존 규칙 유지, undo로 실수 횟수가 줄지 않음)
4. App Store 최종 가격
5. 광고 길이 미보장
6. iPhone 전용 출시(iPad 제외). 한 번 iPad 지원으로 출시하면 이후 iPad를 뺄 수 없으므로, App Store Connect에 iPad를 지원한 기존 기록이 있으면 `TARGETED_DEVICE_FAMILY`를 `"1,2"`로 되돌립니다.
7. iOS 홈 화면 이름을 `Sudoku` 그대로 둘지 `스도쿠`로 바꿀지(AdMob 앱 이름은 `스도쿠`, Android 라벨은 `sudoku JANG`)
8. App Store 가격이 ₩990이 아닐 수 있음(4번과 연결)

**가격 정책(끝자리 내림)**: 기준가 ₩1,000에서 끝자리를 내려 ₩990. Play는 ₩990을 그대로 입력합니다. App Store는 KRW 가격 목록에 ₩990이 있으면 그 값을, 없으면 ₩990 이하에서 가장 높은 가격을 쓰며, 이 경우 사용자 확인이 필요합니다. 해외 가격은 USD $0.99를 기준으로 콘솔이 자동 환산합니다. 앱 코드에는 가격 숫자를 넣지 않고 `ProductDetails.price`만 표시합니다.

## 가격표

| 스토어 | 상품 ID | 설정 가격 | 확인일 | 앱 표시값(`ProductDetails.price`) |
|---|---|---|---|---|
| Play | `remove_ads` | ₩990 | | |
| App Store | `remove_ads` | ₩990 또는 그 이하 최고가 | | |

빈칸은 콘솔에 등록하고 QA를 마친 뒤 채웁니다. 가격 검증은 logcat의 `IAP price=… raw=… cur=KRW` 로그로 합니다.

## 빌드

```powershell
flutter pub get
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
| iOS App ID | 미등록, 테스트 ID | `ios/Flutter/Debug.xcconfig` | `ios/Flutter/Release.xcconfig` `GAD_APPLICATION_ID` (등록 후 Profile은 `[config=Profile]` 줄로 샘플 유지) |
| Android 전면 | 미등록, `androidProd=''` | `ad_ids.dart` `androidSample` | `ad_ids.dart` `androidProd` (dart-define `ADMOB_INTERSTITIAL_ANDROID`로 덮어쓰기) |
| iOS 전면 | 미등록, `iosProd=''` | `ad_ids.dart` `iosSample` | `ad_ids.dart` `iosProd` (dart-define `ADMOB_INTERSTITIAL_IOS`로 덮어쓰기) |

- AdMob 콘솔: iOS 앱 이름 `스도쿠`, 전면광고 단위 `sudoku_pregame_interstitial_ios`로 등록할 예정입니다. **2026-10-21 콘솔 작업 미완료**: 앱 목록에서 `스도쿠`/`sudoku`/`JANG` 앱이 없음을 확인한 뒤 Chrome 확장 연결이 끊겼습니다. 등록 전까지 iOS 릴리스 광고는 `skipped`입니다.
- 등록하면 `Release.xcconfig`에 실제 App ID와 `GAD_APPLICATION_ID[config=Profile]=ca-app-pub-3940256099942544~1458002511` 줄을, `ad_ids.dart`의 `iosProd`에 단위 ID를 넣습니다. 그러면 `test/services/ad_ids_test.dart`의 skip이 자동으로 풀립니다.
- 미등록 앱에는 번들 ID 입력란이 없어 `com.jang.sudoku`는 콘솔에 기록되지 않습니다(출시 후 스토어 연결 E3에서 맞춰짐).
- 광고 단위의 광고 유형을 동영상만으로 좁히면 필 레이트가 떨어질 수 있습니다(콘솔에서 되돌릴 수 있음). 동영상으로 설정해도 광고 길이는 보장되지 않습니다(위 표).

## 맥북에서 할 순서

```sh
flutter --version                      # 3.47.7 이어야 함(다르면 pbxproj 가 바뀜)
flutter pub get
cd ios && pod install --repo-update && cd ..    # Podfile.lock 커밋
open -a Simulator && flutter run       # 샘플 전면광고·ATT 창 확인. 결제 버튼 비활성은 정상
open ios/Runner.xcworkspace            # Signing & Capabilities > Team 선택(1회)
flutter build ipa --release            # 단위 ID 덮어쓰기·테스트 기기: --dart-define-from-file=config/ads.release.json
xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release | grep GAD_APPLICATION_ID
xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner -configuration Profile | grep GAD_APPLICATION_ID
open build/ios/archive/Runner.xcarchive   # Organizer > Distribute App > App Store Connect (업로드만)
```

- 기대값: Release는 실제 App ID, Profile은 `~1458002511`(샘플)입니다. iOS AdMob 등록 전에는 둘 다 샘플입니다.
- 버전은 `pubspec.yaml` 한 곳에서만 관리합니다(현재 `2.0.0+3`). 업로드할 때마다 `+N`을 올리고 `--build-number`는 쓰지 않습니다.
- 업로드는 Xcode Organizer의 "Distribute App"으로 합니다(altool 미사용).
- (선택) 시뮬레이터에서 결제를 확인하려면 Xcode에서 `File > New > StoreKit Configuration File`로 `remove_ads`(Non-Consumable)를 만들고 Scheme > Run > StoreKit Configuration에 지정한 뒤 **Xcode ▶로 실행**합니다. `flutter run`에는 적용되지 않습니다. TestFlight는 이 설정을 무시합니다.
- iOS 시뮬레이터는 실제 광고를 받지 않습니다. 실기기 릴리스 테스트는 테스트 기기를 등록(체크리스트 D4)한 뒤에만 하고, 광고는 클릭하지 않습니다.
- **ATT 채널(`ios/Runner/AppDelegate.swift`, C4 커밋)은 Windows에서 컴파일하지 못했습니다.** 맥에서 빌드가 실패하면 `git revert <C4>`로 되돌리고 UMP IDFA 메시지 게시(체크리스트 D3)에 의존합니다.

## App Store Connect 체크리스트

원본은 [출시 체크리스트 F 블록](docs/release-checklist.md#f-app-store-맥북-로컬--이후-ci)입니다.

1. 앱 생성(번들 `com.jang.sudoku`, 기본 언어 한국어, 이름 `Sudoku JANG`)
2. 유료 앱 계약
3. `remove_ads` 비소모성 상품: ₩990, 없으면 ₩990 이하 최고가(사용자 확인) → README 가격표에 기록
4. App Privacy(기기 ID·광고 데이터, 추적=예, Organizer Privacy Report 참고) + 개인정보처리방침 URL(`TODO_` 0건)
5. 연령 등급
6. 6.9″ iPhone 스크린샷
7. TestFlight 실기기에서 ATT 창, 샌드박스 구매·복원, "복원할 구매가 없어요" 확인
8. 버전 페이지 "앱 내 구입"에 `remove_ads` 첨부(심사용 스크린샷 포함, 빠지면 반려)
9. 심사 메모: "새 게임 시작 시 전면광고, 광고 제거는 비소모성 IAP, 설정 > 구매 복원"
10. 제출(사용자)

## 출시 전 체크리스트

- [출시 체크리스트](docs/release-checklist.md) (원본, 사용자가 바로 할 작업 5개 포함)
- [개인정보처리방침 초안](docs/privacy-policy.md)
- [스토어 등록정보 초안](docs/store-listing.md)

## 알려진 한계

- 광고 길이를 보장하지 않습니다(위 표 참고).
- 노필·오프라인·동의 거부일 때는 광고 없이 시작합니다.
- **AdMob 앱·광고 단위가 아직 등록되지 않았습니다**(iOS·Android 모두. 2026-10-21 iOS 콘솔 작업 중 Chrome 확장 연결이 끊겨 미완료). 릴리스 빌드의 단위 ID가 비어 있어 **iOS·Android 릴리스 광고가 `skipped`**되고, App ID는 테스트 ID로 들어갑니다. 체크리스트 E1-iOS·E1-Android 참고.
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
