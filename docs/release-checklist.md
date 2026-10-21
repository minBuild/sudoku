# 출시 체크리스트 (Sudoku JANG 2.0)

> 체크리스트의 원본은 이 문서입니다. 가격 확정값과 광고 ID 값은 여기에 적지 않고
> [README §가격표](../README.md#가격표)와 README 광고 섹션에만 둡니다.
> Android를 먼저 출시하고, iOS(F 블록)는 macOS CI가 준비된 뒤 진행합니다.

## 사용자가 바로 할 작업 5개

1. [ ] 업로드 키스토어 생성 (B1)
2. [ ] [개인정보처리방침](privacy-policy.md)의 `TODO_` 항목을 채우고 호스팅 (D1·D2)
3. [ ] Play Console에 앱 생성 (C1, C0 결과 앱이 없을 때만)
4. [ ] AdMob 테스트 기기 등록 (D4)
5. [ ] `android/key.properties` 작성 (B2)

> 추가: 이번 작업에서 AdMob 콘솔 작업(E1)을 하지 못했습니다(브라우저 연결 실패).
> E1이 끝나기 전에는 릴리스 빌드에서 광고가 나오지 않습니다.

## 사용자 요구 충족 상태

| # | 요구 | 상태 | 남은 일 |
|---|---|---|---|
| R1 | 디자인 새로, 깔끔하게 | 완료 (2.0 리디자인, Stitch 대응). 회귀 점검만 진행 | A6 |
| R2 | 게임 시작 시 10초 정도 광고 | **미충족**: 흐름은 구현됐지만 릴리스 단위 ID가 비어 있어 `skipped`. 광고 길이는 앱이 정할 수 없음(README 표) | E1 · E3 · D4 |
| R3 | 평생 광고 제거 990원(끝자리 내림) | 코드 하드코딩 0건, `ProductDetails.price`만 표시. 콘솔 상품 등록 남음 | C3 · F3 |

## A. 코드·빌드 (AI)

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | A1 AdMob 실제 ID 4개 반영 (`ad_ids.dart`, `build.gradle.kts` `prodAdmobAppId`, `Release.xcconfig`) | AI | E1 | `test/services/ad_ids_test.dart` 통과 |
| [ ] | A2 업로드할 때마다 `pubspec.yaml` 버전의 `+N`을 1씩 올림 (현재 `2.0.0+3`). C0의 최고 versionCode보다 커야 함 | AI | C0 | `aapt2 dump badging`의 `versionCode` |
| [x] | A3 Manifest 점검: `APPLICATION_ID`, `AD_ID`, `BILLING`, targetSdk 36, minSdk 24 | AI | - | `aapt2 dump badging` / `dump xmltree` |
| [x] | A4 Billing 8 이상 요건: `in_app_purchase_android 0.5.5`가 billing 9.1.0 사용 → 충족 | AI | - | `pubspec.lock` |
| [x] | A5 문서 초안 (이 문서, 개인정보처리방침, 스토어 등록정보) | AI | - | `docs/` 파일 3개 |
| [ ] | A6 스토어 스크린샷을 에뮬레이터로 캡처 (후속 작업) | AI | - | 휴대폰 스크린샷 2장 이상 |

## B. 서명

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | B1 업로드 키스토어 생성: `keytool -genkeypair -v -keystore C:/Users/<you>/keys/sudoku-upload.jks -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload`. 저장소 밖에 두고 백업 | 사용자 | - | 파일 존재, 백업 위치 기록 |
| [ ] | B2 `android/key.properties.example`을 복사해 `android/key.properties` 작성 | 사용자 | B1 | release 빌드에서 `key.properties 없음` 경고가 사라짐 |
| [ ] | B3 Play App Signing 사용 (신규 앱은 필수) | 사용자 | C1 | Play Console > 앱 무결성 |
| [ ] | B4 AAB 서명 확인: `keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab`. `CN=Android Debug`면 실패. 기존 앱이면 SHA-1이 C0 기록값과 같아야 함 (`jarsigner -verify`는 판정 기준 아님) | AI | B2 | Owner / SHA1 출력 |

기존 앱의 업로드 키를 분실했다면 사용자가 Play Console에서 업로드 키 재설정을 요청합니다.

## C. Play Console (사용자)

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | C0 조회: `com.jang.sudoku` 존재·게시 여부, 최고 versionCode, 업로드 키 SHA-1 → **미확인**(2026-10-21, 브라우저 연결 실패). 신규 앱 기준으로 작성 | 사용자/AI | - | 결과를 이 행에 기록 |
| [ ] | C1 앱 생성 (무료, 게임 > 퍼즐) | 사용자 | C0 | 앱 대시보드 |
| [ ] | C2 서명된 AAB를 내부 테스트에 업로드 | 사용자 | B4 | 내부 테스트 트랙에 버전 표시 |
| [ ] | C3 `remove_ads` 비소모성 상품, **₩990**(끝자리 내림). 구매 옵션 '구매' 1개, 하위 호환 지정, 할인 오퍼 없음. 확정 가격은 README 가격표에 기록 | 사용자 | C2 | 내부 테스트 빌드에서 구매 버튼 활성, logcat `IAP price=₩990 … cur=KRW` |
| [ ] | C4 라이선스 테스터 등록. 구매·취소·pending·복원 테스트는 내부 테스트 링크로 설치한 빌드에서만 | 사용자 | C2 | 테스트 구매 성공, 재설치 후 자동 복원 |
| [ ] | C5 스토어 등록 정보([store-listing.md](store-listing.md)): 아이콘 512, 피처 그래픽 1024×500, 휴대폰 스크린샷 2장 이상, 웹사이트는 E4 도메인 루트 | 사용자 | A6 | 등록정보 저장 |
| [ ] | C6 앱 콘텐츠: 방침 URL, 광고 포함 = 예, 광고 ID 사용 = 예, 데이터 보안, 콘텐츠 등급, 타깃 연령 13세 이상 | 사용자 | D2 | 앱 콘텐츠 페이지 모두 완료 |
| [ ] | C7 프로덕션 게시 | 사용자 | C2~C6 | 스토어 페이지 공개 |

## D. 개인정보·동의

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | D1 [개인정보처리방침](privacy-policy.md) 초안을 채움 | 사용자 | - | `TODO_` 검색 결과 0건 |
| [ ] | D2 GitHub Pages 사용자 사이트(`<user>.github.io`) 또는 자체 도메인에 호스팅 | 사용자 | D1 | 로그인 없이 열림 |
| [ ] | D3 UMP 메시지(GDPR, IDFA) 작성·게시. 게시하지 않으면 ATT 창이 뜨지 않아 App Store 5.1.2 반려 위험 | 사용자 | D2 | AdMob > 개인정보 보호 및 메시지에서 게시 상태 |
| [ ] | D4 테스트 기기 등록. 실기기 릴리스 테스트 전에 반드시. 광고는 클릭하지 않음. 내부 테스트 빌드도 실제 광고를 받음 | 사용자 | E1 | `--dart-define-from-file=config/ads.release.json`의 `ADMOB_TEST_DEVICES`, 광고에 "테스트 광고" 표시 |

## E. AdMob

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | E1 앱(`Sudoku JANG`, Android/iOS)과 전면광고 단위(`sudoku_pregame_interstitial_android` / `_ios`) 등록, 광고 유형은 동영상 위주 → **미완료**(브라우저 연결 실패). 완료 후 A1 진행 | AI/사용자 | - | 콘솔 앱·단위 목록, A1 테스트 |
| [ ] | E2 결제 프로필, 주소 PIN | 사용자 | E1 | AdMob > 결제 |
| [ ] | E3 C7 이후 스토어 연결, 앱 검토(수일 소요). 그 전까지는 송출이 제한되어 R2를 체감하기 어려움 | 사용자 | C7 | 앱 상태 "준비됨" |
| [ ] | E4 도메인 루트에 `app-ads.txt`: `google.com, pub-<16자리>, DIRECT, f08c47fec0942fa0` | 사용자 | E1 · D2 | AdMob > 앱 > app-ads.txt 상태 |

## F. App Store (macOS CI 준비 후)

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | F1 Bundle ID `com.jang.sudoku` 등록, App Store Connect 앱 생성 | 사용자 | - | App Store Connect 앱 목록 |
| [ ] | F2 유료 앱 계약 | 사용자 | - | 계약 상태 "활성" |
| [ ] | F3 `remove_ads` 가격 ₩990. 목록에 없으면 ₩990 이하 최고가, **사용자 확인 필요**. 결과는 README 가격표 | 사용자 | F1 · F2 | Sandbox에서 표시 가격 |
| [ ] | F4 App Privacy 라벨(기기 ID, 광고 데이터, 추적 = 예)과 방침 URL | 사용자 | D2 | App Privacy 페이지 |
| [ ] | F5 CI: Xcode 버전 고정, Podfile `platform :ios, '15.0'`, `flutter build ipa`, `xcodebuild -showBuildSettings -configuration Profile/Release`로 `GAD_APPLICATION_ID`가 각각 샘플·실제 값인지 확인, 실기기에서 UIScene·광고 표시 | AI(CI) | A1 | CI 로그 |
| [ ] | F6 Sandbox 구매·복원 | 사용자 | F3 · F5 | 구매 후 광고 사라짐, 재설치 후 복원 |
| [ ] | F7 심사 제출 | 사용자 | F1~F6 | 심사 상태 |

## 블록별 남은 개수 (2026-10-21)

| 블록 | 남음 / 전체 |
|---|---|
| A | 3 / 6 |
| B | 4 / 4 |
| C | 8 / 8 |
| D | 4 / 4 |
| E | 4 / 4 |
| F | 7 / 7 |
