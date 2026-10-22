# 출시 체크리스트 (Sudoku JANG 2.0)

> 체크리스트의 원본은 이 문서입니다. 가격 확정값과 광고 ID 값은 여기에 적지 않고
> [README §가격표](../README.md#가격표)와 README 광고 섹션에만 둡니다.
> Android를 먼저 출시하고, iOS(F 블록)는 맥북에서 로컬로 빌드·업로드합니다(이후 CI).

## 사용자가 바로 할 작업 5개

1. [ ] 업로드 키스토어 생성 (B1)
2. [ ] [개인정보처리방침](privacy-policy.md)의 `TODO_` 항목을 채우고 호스팅 (D1·D2)
3. [ ] Play Console에 앱 생성 (C1, C0 결과 앱이 없을 때만)
4. [ ] AdMob 테스트 기기 등록 (D4)
5. [ ] `android/key.properties` 작성 (B2)

> 추가: E1-iOS 완료(2026-10-22). E1-Android는 이번 범위 밖이라 Android 릴리스 광고는 `skipped`.
> 2026-10-22 콘솔 재대조(E1-iOS) 결과: 일치. 광고 정책 변경: 첫 판부터 15분 간격.

## 사용자 요구 충족 상태

| # | 요구 | 상태 | 남은 일 |
|---|---|---|---|
| R1 | 디자인 새로, 깔끔하게 | 완료 (2.0 리디자인, Stitch 대응). 회귀 점검만 진행 | A6 |
| R2 | 게임 시작 시 10초 정도 광고 | iOS 단위 ID 반영, 맥 빌드와 E3 후 송출. Android 미등록. 광고 길이는 앱이 정할 수 없음(README 표) | E1 · E3 · D4. 첫 판부터 15분 간격(README) |
| R3 | 평생 광고 제거 990원(끝자리 내림) | 코드 하드코딩 0건, `ProductDetails.price`만 표시. 콘솔 상품 등록 남음. 권장가 ₩2,200~2,900대 메모, ₩990과 달라 확정 필요 | C3 · F3 |

## A. 코드·빌드 (AI)

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [x] | A1-iOS iOS App ID(`Release.xcconfig`, Profile 은 샘플 줄)와 단위 ID(`ad_ids.dart` `iosProd`) 반영 | AI | E1-iOS | `test/services/ad_ids_test.dart` 통과(skip 0건) |
| [ ] | A1-Android Android App ID(`key.properties` `admobAppId`)와 단위 ID(`ad_ids.dart` `androidProd`) 반영 | AI | E1-Android | `ad_ids_test` Android 케이스 |
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
| [ ] | C3 `remove_ads` 비소모성 상품, **가격 확정 후**(README §사용자 확인 10) **₩990**(끝자리 내림). 구매 옵션 '구매' 1개, 하위 호환 지정, 할인 오퍼 없음. 확정 가격은 README 가격표에 기록 | 사용자 | C2 | 내부 테스트 빌드에서 구매 버튼 활성, logcat `IAP price=₩990 … cur=KRW` |
| [ ] | C4 라이선스 테스터 등록. 구매·취소·pending·복원 테스트는 내부 테스트 링크로 설치한 빌드에서만 | 사용자 | C2 | 테스트 구매 성공, 재설치 후 자동 복원 |
| [ ] | C5 스토어 등록 정보([store-listing.md](store-listing.md)): 아이콘 512, 피처 그래픽 1024×500, 휴대폰 스크린샷 2장 이상, 웹사이트는 E4 도메인 루트 | 사용자 | A6 | 등록정보 저장 |
| [ ] | C6 앱 콘텐츠: 방침 URL, 광고 포함 = 예, 광고 ID 사용 = 예, 데이터 보안, 콘텐츠 등급, 타깃 연령 13세 이상 | 사용자 | D2 | 앱 콘텐츠 페이지 모두 완료 |
| [ ] | C7 프로덕션 게시 | 사용자 | C2~C6 | 스토어 페이지 공개 |

## D. 개인정보·동의

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | D1 [개인정보처리방침](privacy-policy.md) 초안을 채움 | 사용자 | - | `TODO_` 검색 결과 0건 |
| [ ] | D2 GitHub Pages 사용자 사이트(`<user>.github.io`) 또는 자체 도메인에 호스팅 | 사용자 | D1 | 로그인 없이 열림 |
| [ ] | D3 UMP 메시지. C4 ATT 채널이 있으면 IDFA 메시지는 선택, ATT 블록을 제거했으면 필수(없으면 ATT 창이 뜨지 않아 App Store 5.1.2 반려 위험). GDPR 메시지는 D2 이후 | 사용자 | D2 | AdMob > 개인정보 보호 및 메시지에서 게시 상태 |
| [ ] | D4 테스트 기기 등록. 실기기 릴리스 테스트 전에 반드시. 광고는 클릭하지 않음. 내부 테스트 빌드도 실제 광고를 받음 | 사용자 | E1 | `--dart-define-from-file=config/ads.release.json`의 `ADMOB_TEST_DEVICES`, 광고에 "테스트 광고" 표시 |

## E. AdMob

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [x] | E1-iOS iOS 앱 `스도쿠`(스토어 미등록)와 전면광고 단위 `sudoku_pregame_interstitial_ios` 등록, 광고 유형은 동영상만 → 등록 완료(2026-10-22), 값은 README | AI/사용자 | - | 콘솔 앱·단위 목록, A1-iOS 테스트, 콘솔 DOM 대조(2026-10-22) |
| [ ] | E1-Android Android 앱과 전면광고 단위 `sudoku_pregame_interstitial_android` 등록 → **미완료**(이번 요청 범위 밖). 완료 후 A1-Android | AI/사용자 | - | 콘솔 앱·단위 목록, A1-Android 테스트 |
| [ ] | E2 결제 프로필, 주소 PIN (2026-10-22 콘솔 작업 중 "계정 설정 완료" 배너는 보이지 않았음) | 사용자 | E1 | AdMob > 결제 |
| [ ] | E3 C7 이후 스토어 연결, 앱 검토(수일 소요). 그 전까지는 송출이 제한되어 R2를 체감하기 어려움 | 사용자 | C7 | 앱 상태 "준비됨" |
| [ ] | E4 도메인 루트에 `app-ads.txt`: `google.com, pub-<16자리>, DIRECT, f08c47fec0942fa0` (완성 줄은 [README 광고 섹션](../README.md#광고-id-위치)) | 사용자 | E1 · D2 | AdMob > 앱 > app-ads.txt 상태 |

## F. App Store (맥북 로컬 → 이후 CI)

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | F0 맥북 준비: Xcode 26 이상(iOS 26 SDK, 업로드 전 Apple 공지로 최소 요건 재확인), CocoaPods, Flutter 3.47.7, Xcode에서 Signing Team 선택 | 사용자 | - | `flutter doctor`, `pod --version` |
| [ ] | F1 Bundle ID `com.jang.sudoku` 등록, App Store Connect 앱 생성 | 사용자 | - | App Store Connect 앱 목록 |
| [ ] | F2 유료 앱 계약 | 사용자 | - | 계약 상태 "활성" |
| [ ] | F3 `remove_ads` 가격 **가격 확정 후**(README §사용자 확인 10) ₩990. 목록에 없으면 ₩990 이하 최고가, **사용자 확인 필요**. 결과는 README 가격표 | 사용자 | F1 · F2 | Sandbox에서 표시 가격 |
| [ ] | F4 App Privacy 라벨(기기 ID, 광고 데이터, 추적 = 예)과 방침 URL | 사용자 | D2 | App Privacy 페이지, **TestFlight 실기기에서 ATT 창이 뜨는지 확인(필수)** |
| [ ] | F4b 마케팅 URL·지원 URL = E4 도메인 루트(AdMob이 app-ads.txt를 찾는 위치) | 사용자 | D2 · F1 | App Store Connect 앱 정보·버전 페이지 URL |
| [ ] | F5 [README "맥북에서 할 순서"](../README.md#맥북에서-할-순서): `pod install`, 시뮬레이터 확인, `flutter build ipa`, `-showBuildSettings`로 `GAD_APPLICATION_ID`가 Release=실제·Profile=샘플인지 확인, Organizer 업로드. 샘플 단위 빌드 게이트: 심사용 빌드는 `DART_DEFINES`에 `ADMOB_INTERSTITIAL_IOS`가 없어야 하고, `+N`이 TestFlight 빌드보다 커야 하며(같은 번호 재업로드 금지), 실제 단위 빌드는 D4 이후. 실제 단위 빌드는 첫 판부터 광고가 나오므로 D4 이후 실행, 테스트 중 광고 클릭 금지 | 사용자 | F0 · A1-iOS | Organizer 업로드 완료, TestFlight 빌드 표시 |
| [ ] | F6 Sandbox 구매·복원, 구매 없는 계정에서 "복원할 구매가 없어요" 표시 | 사용자 | F3 · F5 | 구매 후 광고 사라짐, 재설치 후 자동 복원 |
| [ ] | F6b 실기기 QA(아래 표). 결과를 표에 기록 | 사용자 | F5 · F6 · D4 | 14개 상황 모두 기대 결과 |
| [ ] | F7 버전 페이지 "앱 내 구입"에 `remove_ads` 첨부(심사용 스크린샷 포함, 빠지면 반려) | 사용자 | F3 | 버전 페이지 앱 내 구입 목록 |
| [ ] | F8 심사 메모: "새 게임 시작 시 전면광고(첫 판부터, 이후 15분 간격), 광고 제거는 비소모성 IAP, 설정 > 구매 복원. ATT 창은 첫 실행 시 홈 화면이 뜬 직후 표시됩니다. 설정 > 개인정보 보호 및 보안 > 추적 > '앱이 추적을 요청하도록 허용'이 꺼져 있으면 iOS가 창을 띄우지 않습니다." | 사용자 | - | 앱 심사 정보 메모란 |
| [ ] | F9 심사 제출 | 사용자 | F1~F8 | 심사 상태 |

### F6b 실기기 QA

| # | 상황 | 기대 결과 | 결과 |
|---|---|---|---|
| 1 | 광고 제거 구매 후 새 게임 | 광고 없이 즉시 시작 | |
| 2 | 구매 복원 후 새 게임 | 광고 없음 | |
| 3 | ATT 거부 | 광고 요청은 되고 게임이 정상 시작됨 | |
| 4 | ATT 허용 후 광고 송출 | 광고를 닫으면 게임이 **정확히 1번** 시작됨(보드 1개, 타이머 0초부터). 이어하기 세이브는 광고 중에 덮어써지지 않고 새 판 시작 시점에만 교체됨 | |
| 5 | 광고 중 앱을 백그라운드로 보냈다가 복귀 | 게임이 중복 시작되지 않음 | |
| 6 | 오프라인 또는 no-fill | 약 3초 뒤 빈 화면 없이 광고 없이 시작 | |
| 7 | 게임 중 제어 센터를 내림 | 타이머가 멈추고, 복귀하면 다시 흐름 | |
| 8 | 앱 실행 후 첫 새 게임 | 전면광고 | |
| 9 | 광고를 닫고 15분 안에 새 게임(쉬움 연속) | 광고 없이 약 300ms 안에 시작 | |
| 10 | 마지막 광고 15분 뒤 새 게임 | 광고 | |
| 11 | no-fill·오프라인 직후 다음 새 게임 | 광고를 다시 시도 | |
| 12 | 15분 경과 후 이어하기 / 같은 퍼즐 다시 / 재시작 | 광고 없음 | |
| 13 | 새 게임 연타 | 광고 1회 | |
| 14 | 광고 중 앱 강제 종료 후 재실행 → 새 게임 | 광고(의도된 동작) | |

15분 경계(14:59/15:00)와 시계 역행은 `test/services/ad_schedule_test.dart`가 검증합니다.

UMP 갱신 무응답 시나리오는 실기기에서 재현할 수 없으므로 단위 테스트(`test/services/consent_service_test.dart`)로 대신합니다.

## 블록별 남은 개수 (2026-10-22)

| 블록 | 남음 / 전체 |
|---|---|
| A | 3 / 7 |
| B | 4 / 4 |
| C | 8 / 8 |
| D | 4 / 4 |
| E | 4 / 5 |
| F | 12 / 12 |
