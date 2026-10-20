# Sudoku JANG 2.0

Flutter 스도쿠 앱. Android 먼저 출시하고, iOS는 코드와 설정만 반영했습니다(빌드 검증은 macOS CI).

- 패키지명 `sudoku`, Android `com.jang.sudoku`, 버전 `2.0.0+3`
- 확인한 Flutter 버전: 3.47.7 (Dart 3.13.5)

## 사용자 요구 대비 동작

| 사용자 요구 | 실제 구현 | 요구와 다른 점 (사용자에게 반드시 고지) |
|---|---|---|
| "디자인부터 새로, 훨씬 깔끔하게" | 디자인 토큰(`ThemeExtension`)과 `CustomPainter` 한 장으로 그리는 보드로 라이트 테마를 새로 구성 | 다크 테마는 이번 범위가 아닙니다. 토큰 구조만 미리 만들어 둡니다. |
| "게임 시작할 때 10초 정도 광고 한 편" | 새 퍼즐을 시작하기 직전에 AdMob **전면광고**(Interstitial)를 1회 보여 줍니다. AdMob 콘솔에서 광고 단위를 **동영상 위주**로 설정합니다. | **광고 길이는 앱이 정할 수 없습니다.** 광고 네트워크가 소재를 고르기 때문에 보통 5~30초이고, 동영상은 5초 뒤 건너뛰기가 될 수 있으며, 정적 이미지 광고가 나오면 1~2초 만에 닫힐 수도 있습니다. 광고를 받지 못하면(오프라인, 노필, 동의 거부) **광고 없이 최대 약 3초 뒤 게임이 시작됩니다.** 시청을 강제할 수 있는 보상형(Rewarded) 광고는 정책상 "사용자가 선택해 보는 광고"여야 해서 쓸 수 없습니다. 광고를 10초 동안 붙잡아 두는 인위적 대기도 정책 위반 위험이 있어 넣지 않습니다. |
| "평생 광고 제거 990원(끝자리 내림 가격)" | 비소모성 상품 `remove_ads` 1개를 둡니다. 가격은 **스토어 콘솔에서** 설정하고, 앱은 스토어가 돌려주는 `ProductDetails.price`만 표시합니다. | **Google Play**: ₩990으로 바로 설정할 수 있습니다. **App Store**: Apple의 KRW 가격 목록에 ₩990이 있으면 ₩990, 없으면 **₩990 이하 가격 중 가장 높은 값**으로 정합니다. 이 경우 ₩990과 달라지므로 사용자 확인이 필요합니다. 해외 가격은 각 콘솔이 자동 환산합니다(USD 기준가 $0.99). 확정한 가격은 README §가격표에 기록합니다. |

### 사용자 확인이 필요한 변경

1. 이어하기 기능 추가 (자동 저장 1슬롯)
2. "숫자 먼저 선택" 입력 방식 삭제 → "칸 선택 → 숫자 입력"으로 통일
3. 실수 5회면 게임 오버 (기존 규칙 유지, undo로 실수 횟수가 줄지 않음)
4. App Store 최종 가격
5. 광고 길이 미보장

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

# 릴리스: 광고 단위 ID는 dart-define 파일로 주입
#   config/ads.example.json 을 복사해 config/ads.release.json 을 만든다 (git 제외)
flutter build appbundle --release --dart-define-from-file=config/ads.release.json
```

- `android/key.properties`(git 제외)가 없으면 릴리스도 디버그 키로 서명됩니다. 파일이 있는데 키가 빠졌으면 명확한 메시지로 실패합니다.
- 실제 AdMob App ID는 `android/key.properties`의 `admobAppId`에 넣습니다. 없으면 테스트 App ID를 쓰고 경고를 남깁니다.
- iOS App ID는 `ios/Flutter/Release.xcconfig`의 `GAD_APPLICATION_ID`를 교체합니다(현재 테스트 ID).
- 릴리스 빌드에 광고 단위 ID가 비어 있으면 광고는 건너뜁니다(`skipped`).

## 출시 전 체크리스트

- **Play Console**
  - BILLING 권한이 포함된 AAB를 내부 테스트에 올린 뒤 `remove_ads`(비소모성, **₩990**, USD $0.99 기준으로 자동 환산)를 만듭니다.
  - 광고 포함, 광고 ID, 데이터 보안 항목을 신고하고 타깃 연령은 13세 이상으로 설정합니다.
  - 스토어 설명에 "광고 포함·인앱결제"를 넣습니다.
- **AdMob**
  - 전면광고 단위를 동영상 위주로 설정합니다.
  - 테스트 기기를 등록합니다(`ADMOB_TEST_DEVICES`).
  - UMP 메시지(GDPR, IDFA)를 작성합니다.
- **App Store Connect**
  - 유료 앱 계약을 맺습니다.
  - `remove_ads` 가격은 ₩990, 없으면 **₩990 이하 중 가장 높은 가격**으로 정합니다. 결과는 가격표에 적고 사용자에게 보고합니다.
- **macOS CI**
  - Xcode 버전을 고정합니다.
  - 첫 `flutter build ipa` 실행 후 Podfile에 `platform :ios, '15.0'`과 post_install 배포 타깃 통일을 넣고 커밋합니다.
  - 실기기에서 광고 표시와 UIScene을 확인합니다(UIScene 마이그레이션 반영됨: `FlutterImplicitEngineDelegate`, `UIApplicationSceneManifest`).
- **릴리스 노트**: "칸 선택 → 숫자 입력 방식으로 통일", "이어하기 추가"

## 알려진 한계

- 광고 길이를 보장하지 않습니다(위 표 참고).
- 노필·오프라인·동의 거부일 때는 광고 없이 시작합니다.
- 생성기는 유일해를 유지하며 한 번만 훑기 때문에 목표 빈칸 수에 못 미칠 수 있습니다. 측정치(난이도별 30판, Windows 개발 PC):

  | 난이도 | 목표 | 최소 수용 | 평균 | 최소~최대 |
  |---|---|---|---|---|
  | 쉬움 | 38 | 38 | 38.0 | 38~38 |
  | 보통 | 45 | 45 | 45.0 | 45~45 |
  | 어려움 | 52 | 48 | 52.0 | 52~52 |
  | 전문가 | 58 | 50 | 56.6 | 54~58 |
  | 지옥 | 62 | 50 | 56.4 | 55~58 |

  **지옥과 전문가의 실제 빈칸 차이는 거의 없습니다.**
