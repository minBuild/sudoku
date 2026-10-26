# 출시 체크리스트 (Sudoku JANG 2.0)

> 체크리스트의 원본은 이 문서입니다. 가격 확정값과 광고 ID 값은 여기에 적지 않고
> [README §가격표](../README.md#가격표)와 README 광고 섹션에만 둡니다.
> Android를 먼저 출시하고, iOS(F 블록)는 맥북에서 로컬로 빌드·업로드합니다(이후 CI).

## 사용자가 바로 할 작업

### iOS(맥북) 트랙 5개 — README "맥북 출시까지 남은 일"과 같은 순서

1. [x] IAP 가격 결정 → **USD $0.49**(2026-10-26) → F3
2. [x] 개인정보처리방침 호스팅 → https://minbuild.github.io/sudoku/privacy.html, `legal_links.dart` 반영 (D1·D2·A8, 2026-10-26)
3. [ ] App Store Connect 앱 생성(번들 `io.minbuild.sudoku`, 기본 언어 English(U.S.) + 한국어 현지화)·유료 앱 계약·`remove_ads` $0.49 (F1·F2·F3)
4. [ ] 맥 빌드·TestFlight·테스트 기기 등록 (F5·D4). F0(pod install·Team)은 2026-10-26 완료
5. [ ] 제출 (F9)

### Android 트랙 (출시 보류, 2026-10-26 사용자 결정)

1. [ ] 업로드 키스토어 생성 (B1)
2. [ ] `android/key.properties` 작성 (B2)
3. [ ] Play Console에 앱 생성 (C1, C0 결과 앱이 없을 때만)
4. [x] AdMob Android 앱·전면 단위 등록 (E1-Android → A1-Android, 2026-10-26 완료)

### 주간 대결·보상형 광고 트랙 (양 플랫폼 공통)

1. [ ] AdMob 보상형 단위 2개 생성 → `ad_ids.dart` 반영 (E5)
2. [ ] Firebase 프로젝트·앱·익명 인증·Firestore·규칙 게시·Playground (H1~H7) → `lib/firebase_options.dart` 반영. 그 전까지 주간 대결은 앱에서 숨겨짐
3. [ ] 신고 이메일 `supportEmail` 결정·반영 (H10)

> 추가: E1-iOS 완료(2026-10-22), E1-Android 완료(2026-10-26).
> 2026-10-22 콘솔 재대조(E1-iOS) 결과: 일치. 광고 정책 변경: 첫 판부터 15분 간격.

## 사용자 요구 충족 상태

| # | 요구 | 상태 | 남은 일 |
|---|---|---|---|
| R1 | 디자인 새로, 깔끔하게 | 완료 (2.0 리디자인, Stitch 대응). 회귀 점검만 진행 | A6 |
| R2 | 게임 시작 시 10초 정도 광고 | iOS·Android 단위 ID 반영, 빌드와 E3 후 송출. 광고 길이는 앱이 정할 수 없음(README 표) | E1 · E3 · D4. 첫 판부터 15분 간격(README) |
| R3 | 평생 광고 제거 1회 구매 | 코드 하드코딩 0건, `ProductDetails.price`만 표시. 가격 **USD $0.49** 확정(2026-10-26). 콘솔 상품 등록 남음 | F3 (C3는 Android 출시 시) |

## A. 코드·빌드 (AI)

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [x] | A1-iOS iOS App ID(`Release.xcconfig`, Profile 은 샘플 줄)와 단위 ID(`ad_ids.dart` `iosProd`) 반영 | AI | E1-iOS | `test/services/ad_ids_test.dart` 통과(skip 0건) |
| [x] | A1-Android Android App ID(`build.gradle.kts` `prodAdmobAppId`)와 단위 ID(`ad_ids.dart` `androidProd`) 반영 | AI | E1-Android | `ad_ids_test` Android 짝 불변식, `flutter build appbundle --release` 경고에 `prodAdmobAppId 비어 있음` 없음 |
| [ ] | A2 업로드할 때마다 `pubspec.yaml` 버전의 `+N`을 1씩 올림 (현재 `2.0.0+3`). C0의 최고 versionCode보다 커야 함 | AI | C0 | `aapt2 dump badging`의 `versionCode` |
| [x] | A3 Manifest 점검: `APPLICATION_ID`, `AD_ID`, `BILLING`, targetSdk 36, minSdk 24 | AI | - | `aapt2 dump badging` / `dump xmltree` |
| [x] | A4 Billing 8 이상 요건: `in_app_purchase_android 0.5.5`가 billing 9.1.0 사용 → 충족 | AI | - | `pubspec.lock` |
| [x] | A5 문서 초안 (이 문서, 개인정보처리방침, 스토어 등록정보) | AI | - | `docs/` 파일 3개 |
| [ ] | A6 스토어 스크린샷을 에뮬레이터로 캡처 (후속 작업) | AI | - | 휴대폰 스크린샷 2장 이상 |
| [x] | A7 다국어 33개 언어(README §지원 언어) ARB, 폴백 en, 해석 콜백(`no→nb`, `zh-TW/HK/MO→번체`, 2순위 언어), iOS CFBundleLocalizations·InfoPlist.xcstrings·knownRegions | AI | - | test/l10n/*, ios_config_test 통과 |
| [x] | A8 앱 내 개인정보처리방침 링크(설정, `url_launcher`). URL https://minbuild.github.io/sudoku/privacy.html 반영(2026-10-26) | AI | D2 | `settings_privacy_link_test`, `legal_links_test` skip 0 |
| [ ] | A9 수동 게이트: 효과음 4종 사람 청취 승인(tap < wrong < solved, 피로감 없음). 소리를 바꾸면 `dart run tool/gen_sounds.dart` 후 다시 청취 | 사용자 | - | `assets/sounds/*.wav` 청취 기록(검수자·날짜) |
| [ ] | A10 수동 게이트: `design/icon/contact_sheet.png` 승인(20px에서 앰버 점 구분, 0.35 타일이 사라지지 않음) | 사용자 | - | 승인 기록. 바꾸면 `RENDER_ICON=1` 렌더 후 `dart run flutter_launcher_icons` |
| [ ] | A11 Android 실기기 게이트(사용자 기기): 시스템 터치음 ON에서 숫자패드·툴바 이중음 없음, 200회 연타 뒤에도 소리와 앱이 정상 | 사용자 | - | 실기기 확인 기록 |
| [x] | A12 번들·Android 앱 ID `com.jang.sudoku` → `io.minbuild.sudoku`(2026-10-26, 사용자 요청). pbxproj·build.gradle.kts·Kotlin 패키지·`ios_config_test` | AI | - | `ios_config_test` 통과, `grep com.jang` 코드 0건 |

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
| [ ] | C0 조회: `io.minbuild.sudoku` 존재·게시 여부, 최고 versionCode, 업로드 키 SHA-1 → **미확인**(2026-10-21, 브라우저 연결 실패). 신규 앱 기준으로 작성 | 사용자/AI | - | 결과를 이 행에 기록 |
| [ ] | C1 앱 생성 (무료, 게임 > 퍼즐) | 사용자 | C0 | 앱 대시보드 |
| [ ] | C2 서명된 AAB를 내부 테스트에 업로드 | 사용자 | B4 | 내부 테스트 트랙에 버전 표시 |
| [ ] | C3 `remove_ads` 비소모성 상품, **USD $0.49** 기준(KRW는 콘솔 환산). 구매 옵션 '구매' 1개, 하위 호환 지정, 할인 오퍼 없음. 표시값은 README 가격표에 기록 | 사용자 | C2 | 내부 테스트 빌드에서 구매 버튼 활성, logcat `IAP price=… cur=KRW` |
| [ ] | C4 라이선스 테스터 등록. 구매·취소·pending·복원 테스트는 내부 테스트 링크로 설치한 빌드에서만 | 사용자 | C2 | 테스트 구매 성공, 재설치 후 자동 복원 |
| [ ] | C5 스토어 등록 정보([store-listing.md](store-listing.md)): 아이콘 512, 피처 그래픽 1024×500, 휴대폰 스크린샷 2장 이상, 웹사이트는 E4 도메인 루트. 메모: Play 512 아이콘 = `design/icon/icon.png` 다운스케일. 피처 그래픽은 `#3B5BDB` 바탕 + 양화 마크 + 워드마크로 후속 | 사용자 | A6 | 등록정보 저장 |
| [ ] | C6 앱 콘텐츠: 방침 URL, 광고 포함 = 예, 광고 ID 사용 = 예, 데이터 보안, 콘텐츠 등급, 타깃 연령 13세 이상 | 사용자 | D2 | 앱 콘텐츠 페이지 모두 완료 |
| [ ] | C7 프로덕션 게시 | 사용자 | C2~C6 · G1 · G2 · G3 · G4 · E5 · H | 스토어 페이지 공개 |

## D. 개인정보·동의

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [x] | D1 [개인정보처리방침](privacy-policy.md) 초안을 채움(운영자 minBuild, hayaeseong@gmail.com, 시행일 2026-10-26) | AI | - | `TODO_` 검색 결과 0건 |
| [x] | D2 https://minbuild.github.io/sudoku/privacy.html (영어 `/sudoku/en/privacy.html`, 소개 `/sudoku/`, 지원 `/sudoku/support.html`)에 호스팅, 2026-10-26 | AI | D1 | 로그인 없이 열림 |
| [ ] | D3 UMP 메시지. C4 ATT 채널이 있으면 IDFA 메시지는 선택, ATT 블록을 제거했으면 필수(없으면 ATT 창이 뜨지 않아 App Store 5.1.2 반려 위험). GDPR 메시지는 D2 이후. 메시지 언어에 앱 지원 33개 언어(README §지원 언어)와 EEA 지역 언어 추가. 언어 추가는 사용자가 메시지를 **게시**해야 반영됨. EEA 언어의 Google 기본 번역 여부는 콘솔에서 확인 | 사용자 | D2 | AdMob > 개인정보 보호 및 메시지에서 게시 상태 |
| [ ] | D4 테스트 기기 등록. 실기기 릴리스 테스트 전에 반드시. 광고는 클릭하지 않음. 내부 테스트 빌드도 실제 광고를 받음 | 사용자 | E1 | `--dart-define-from-file=config/ads.release.json`의 `ADMOB_TEST_DEVICES`, 광고에 "테스트 광고" 표시. **Android**: 테스트 기기 해시는 logcat의 `setTestDeviceIds(...)` 줄에서 얻고, 해시를 넣기 전 첫 실행 때는 새 게임을 시작하지 않음 |

## E. AdMob

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [x] | E1-iOS iOS 앱 `스도쿠`(스토어 미등록)와 전면광고 단위 `sudoku_pregame_interstitial_ios` 등록, 광고 유형은 동영상만 → 등록 완료(2026-10-22), 값은 README | AI/사용자 | - | 콘솔 앱·단위 목록, A1-iOS 테스트, 콘솔 DOM 대조(2026-10-22) |
| [x] | E1-Android Android 앱 `스도쿠`(스토어 미등록)와 전면광고 단위 `sudoku_pregame_interstitial_android` 등록, 광고 유형은 동영상만, 게재빈도 설정 없음 → 등록 완료(2026-10-26), 값은 README | AI | - | 콘솔 앱·단위 목록 텍스트 대조(2026-10-26), A1-Android 테스트 |
| [ ] | E2 결제 프로필, 주소 PIN (2026-10-22 콘솔 작업 중 "계정 설정 완료" 배너는 보이지 않았음) | 사용자 | E1 | AdMob > 결제 |
| [ ] | E3 C7 이후 스토어 연결, 앱 검토(수일 소요). 그 전까지는 송출이 제한되어 R2를 체감하기 어려움 | 사용자 | C7 | 앱 상태 "준비됨" |
| [x] | E4 https://minbuild.github.io/app-ads.txt 에 `google.com, pub-7432278320907197, DIRECT, f08c47fec0942fa0` 게시됨(다른 앱과 같은 퍼블리셔, 이미 있음). AdMob 크롤링 확인은 스토어 연결(E3) 뒤 | AI | E1 · D2 | AdMob > 앱 > app-ads.txt 상태 |
| [ ] | E5 보상형 광고 단위 생성: 먼저 앱 `스도쿠` Android(`~1580424878`)·iOS(`~4407658951`) 단위 목록을 조회해 보상형 단위가 있으면 재사용, 없으면 `sudoku_reward_android` / `sudoku_reward_ios`(보상 1개 `hint`, 서버 측 확인·게재빈도 설정 끔) 생성 → `ad_ids.dart` `androidRewardedProd`/`iosRewardedProd` 반영, README 광고 ID 표 2행 기록. **미완료**(2026-10-29, 브라우저 미연결). 그 전까지 릴리스 빌드에서 보상형은 항상 `unavailable`(무료 힌트·광고 제거 경로는 정상) | AI/사용자 | E1 | 콘솔 단위 목록 텍스트 대조, `ad_ids_test` 통과 |

## F. App Store (맥북 로컬 → 이후 CI)

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [x] | F0 맥북 준비: Xcode, CocoaPods(`pod install`), Signing Team 선택 → 2026-10-26 사용자 완료. 번들 ID가 `io.minbuild.sudoku`로 바뀌었으므로 Xcode 자동 서명이 새 ID를 등록하는지 한 번 확인 | 사용자 | - | `flutter doctor`, `pod --version` |
| [ ] | F1 Bundle ID `io.minbuild.sudoku` 등록, App Store Connect 앱 생성. 기본 언어 English(U.S.), 한국어 현지화 추가 | 사용자 | - | App Store Connect 앱 목록·앱 정보 > 기본 언어 |
| [ ] | F2 유료 앱 계약 | 사용자 | - | 계약 상태 "활성" |
| [ ] | F3 `remove_ads` 비소모성, 기준가 **USD $0.49**(다른 통화는 Apple 자동 환산). 확인한 KRW 표시값은 README 가격표에 기록 | 사용자 | F1 · F2 | Sandbox에서 표시 가격 |
| [ ] | F4 App Privacy 라벨(기기 ID, 광고 데이터, 추적 = 예)과 방침 URL(영어 https://minbuild.github.io/sudoku/en/privacy.html, 한국어 `/sudoku/privacy.html`) | 사용자 | D2 | App Privacy 페이지, **TestFlight 실기기에서 ATT 창이 뜨는지 확인(필수)** |
| [ ] | F4b 마케팅 URL https://minbuild.github.io/sudoku/ · 지원 URL https://minbuild.github.io/sudoku/support.html (도메인 루트에 app-ads.txt가 있어 AdMob 확인 가능) | 사용자 | D2 · F1 | App Store Connect 앱 정보·버전 페이지 URL |
| [ ] | F5 [README "맥북에서 할 순서"](../README.md#맥북에서-할-순서): `pod install`, 시뮬레이터 확인, `flutter build ipa`, `-showBuildSettings`로 `GAD_APPLICATION_ID`가 Release=실제·Profile=샘플인지 확인, Organizer 업로드. 샘플 단위 빌드 게이트: 심사용 빌드는 `DART_DEFINES`에 `ADMOB_INTERSTITIAL_IOS`가 없어야 하고, `+N`이 TestFlight 빌드보다 커야 하며(같은 번호 재업로드 금지), 실제 단위 빌드는 D4 이후. 실제 단위 빌드는 첫 판부터 광고가 나오므로 D4 이후 실행, 테스트 중 광고 클릭 금지. 아카이브 `.lproj` 34개(Base 포함)와 `{zh-Hans,zh-Hant,ar,ko}.lproj/InfoPlist.strings` 확인(README). **Mac 게이트(Firebase)**: Firebase pod(`firebase_core`·`firebase_auth`·`cloud_firestore`)를 포함한 첫 `pod install` 소요 시간과 첫 `flutter build ipa` 시간을 이 행에 기록(Firestore pod는 첫 빌드가 오래 걸림). `GoogleService-Info.plist`는 추가하지 않음(Dart 초기화) | 사용자 | F0 · A1-iOS | Organizer 업로드 완료, TestFlight 빌드 표시, pod install·빌드 시간 기록 |
| [ ] | F6 Sandbox 구매·복원, 구매 없는 계정에서 "복원할 구매가 없어요" 표시 | 사용자 | F3 · F5 | 구매 후 광고 사라짐, 재설치 후 자동 복원 |
| [ ] | F6b 실기기 QA(아래 표). 결과를 표에 기록 | 사용자 | F5 · F6 · D4 · E5 · H | 40개 상황 모두 기대 결과 |
| [ ] | F7 버전 페이지 "앱 내 구입"에 `remove_ads` 첨부(심사용 스크린샷 포함, 빠지면 반려) | 사용자 | F3 | 버전 페이지 앱 내 구입 목록 |
| [ ] | F8 심사 메모(영어 병기): 한국어 "새 게임 시작 시 전면광고(첫 판부터, 이후 15분 간격), 광고 제거는 비소모성 IAP, 설정 > 구매 복원. 개인정보처리방침은 설정 > 개인정보처리방침. ATT 창은 첫 실행 시 홈 화면이 뜬 직후 표시됩니다. 설정 > 개인정보 보호 및 보안 > 추적 > '앱이 추적을 요청하도록 허용'이 꺼져 있으면 iOS가 창을 띄우지 않습니다. 보상형 광고는 이용자가 버튼을 눌렀을 때만 표시되며(무료 힌트 하루 3회 이후의 힌트, 실수 5회 후 이어 도전), 전면광고를 대체하지 않습니다. 광고 제거 구매자는 힌트 무제한, 이어 도전 즉시. 주간 대결은 Firebase 익명 인증을 쓰며 계정이 필요 없습니다. 닉네임은 이용자가 정하며, 주간 대결 화면의 '부적절한 닉네임 신고'(이메일)로 신고하면 개발자가 삭제합니다." / English "An interstitial ad is shown when starting a new game (from the first game, then at most once every 15 minutes). Remove Ads is a non-consumable IAP; Settings > Restore Purchases. Privacy policy: Settings > Privacy Policy. The ATT prompt appears right after the home screen on first launch. iOS does not show it if Settings > Privacy & Security > Tracking > 'Allow Apps to Request to Track' is off. Rewarded ads are shown only when the user taps a button (a hint after the 3 free daily hints, or continuing after 5 mistakes); they do not replace interstitials. Remove Ads purchasers get unlimited hints and continue without an ad. The weekly challenge uses Firebase Anonymous Authentication; no account is needed. Nicknames are chosen by users; objectionable nicknames can be reported via 'Report a nickname' (email) on the weekly challenge screen and are removed by the developer." | 사용자 | - | 앱 심사 정보 메모란 |
| [ ] | F9 심사 제출 | 사용자 | F1~F8 · G1~G5 · E5 · H | 심사 상태 |

## G. 다국어(사용자)

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | G1 en·ko 번역 검수(`lib/l10n/app_en.arb`, `app_ko.arb`) | 사용자 | A7 | 검수자·날짜 기록 |
| [ ] | G2 **법적 문구 검수(검수 전 출시 금지)**: ATT 문구 ko·en, `privacyOptions*`, `privacyPolicy`, 개인정보처리방침 ko·en | 사용자 | A7 | 검수자·날짜 기록 |
| [ ] | G3 31개 언어는 사용자 지시로 미검수 출시(README 사용자 확인 11). 문제가 보고되면 README 플랜 B로 제외 | 사용자 | A7 | 보고 접수 시 제외 커밋 |
| [ ] | G4 스토어 등록정보(Play·App Store Connect) 기본 언어 영어(U.S.) **출시 필수**, 한국어 현지화 **필수**, 그 밖의 언어는 권장(사람이 번역). 언어별 스크린샷 | 사용자 | C5 · F1 | 콘솔 등록정보 언어 목록 |
| [x] | G5 개인정보처리방침 영어본 호스팅 https://minbuild.github.io/sudoku/en/privacy.html (2026-10-26). App Store Connect 언어별 방침 URL 입력은 F4 | AI | D2 | 로그인 없이 열림 |

## H. Firebase(주간 대결)

> 2026-10-29 기준 **H 전체 미완료**(이번 작업에서 브라우저가 연결되지 않아 콘솔 작업을 하지 못함). `lib/firebase_options.dart`가 `TODO`인 동안 홈 주간 대결 카드와 설정 닉네임 행은 숨겨집니다. 결과는 [README §Firebase](../README.md#firebase)에 기록합니다.
> 공통 금지: 결제·요금제(Blaze 포함) 변경, 계정 권한 변경, 기존 항목 삭제·수정.

| [ ] | 항목 | 담당 | 선행 | 어떻게 확인하나 |
|---|---|---|---|---|
| [ ] | H1 프로젝트: 목록을 먼저 조회해 있으면 재사용, 없으면 `sudoku-jang` 생성. Google Analytics 끔, **Spark 요금제 유지** | AI/사용자 | - | Firebase 콘솔 프로젝트 목록, 요금제 Spark |
| [ ] | H2 앱 2개 등록: Android·iOS `com.jang.sudoku`(SDK 안내 단계 건너뜀). 설정 파일은 새 빈 임시 폴더(`%TEMP%\sudoku-fb-<날짜>\`)에 받아 필요한 값만 `lib/firebase_options.dart`에 넣고 폴더 삭제. `google-services.json`·`GoogleService-Info.plist`는 **커밋하지 않음** | AI/사용자 | H1 | `firebaseConfigured == true`, `git status --porcelain \| Select-String 'google-services\|GoogleService-Info'` 출력 0 |
| [ ] | H3 Authentication > 익명 로그인 사용 설정 | AI/사용자 | H1 | 로그인 방법 목록에 익명 "사용 설정됨" |
| [ ] | H4 Firestore 생성: 리전 `asia-northeast3`(서울), 프로덕션 모드. 결제 연결을 요구하면 중단 | AI/사용자 | H1 | Firestore 데이터베이스 위치 표시 |
| [ ] | H5 규칙 게시: `firebase/firestore.rules` 내용을 붙여넣고 **게시**(사용자 승인 시에만) | 사용자 | H4 | 규칙 탭 게시 시각 |
| [ ] | H6 Rules Playground 10케이스([firebase/rules_cases.md](../firebase/rules_cases.md)) 실행·결과 기록 | AI/사용자 | H5 | 표의 결과 칸 10개가 모두 기대값과 같음 |
| [ ] | H7 (선택) TTL: 컬렉션 그룹 `entries`의 `expireAt`(주 종료 + 56일)에 TTL 정책. 요금제 변경을 요구하면 건너뜀. 설정하면 [개인정보처리방침](privacy-policy.md) §4를 "주 종료 후 8주"로 고침, 못 하면 "삭제 요청 시까지" 유지 | AI/사용자 | H4 | Firestore > TTL 정책 상태 "제공 중" |
| [ ] | H8 API 키 제한: Google Cloud 콘솔에서 Android 키는 패키지명+SHA-1(업로드·앱 서명 키), iOS 키는 번들 ID로 제한. **apiKey는 공개값이며 키 제한은 사람이 함**(AI 금지 항목) | 사용자 | H2 · B1 · B3 | 사용자 인증 정보 > API 키 > 애플리케이션 제한사항 |
| [ ] | H9 실기기 연결 확인: 디버그 빌드에서 홈 주간 대결 카드가 보이고, 주간 퍼즐 클리어 후 Firestore `weekly/{board}/entries/{uid}`에 문서 생성(`ms`·`nick`·`hintUsed=false`·`v=1`·`updatedAt`·`expireAt`) | 사용자 | H2~H5 | Firestore 데이터 탭 |
| [ ] | H10 `lib/services/legal_links.dart` `supportEmail` 결정·반영(현재 `''` → 주간 대결 화면의 "부적절한 닉네임 신고" 행 숨김). 방침 §8 이메일과 같게 | 사용자 | D1 | 주간 대결 화면에 신고 행 표시, 탭하면 메일 앱 열림 |
| [ ] | H11 신고 처리 절차 숙지: 신고 메일 접수 → Firestore 콘솔 `weekly/<주>_<난이도>_g1/entries`에서 해당 닉네임 문서를 찾음 → 문서의 `nick`을 `''`로 수정(기록 유지, 화면에는 "익명") 또는 문서 삭제(삭제 요청인 경우) → 회신. 규칙상 앱은 삭제할 수 없으므로 콘솔에서만 처리 | 사용자 | H5 · H10 | 처리 기록(날짜·문서 경로) |
| [ ] | H12 개인정보처리방침·스토어 데이터 보안·App Privacy에 Firebase 반영 확인(방침 §1~§7, store-listing 표) | 사용자 | H1~H7 | 문서 대조 |

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
| 15 | 이어하기 저장이 있는 상태에서 기기 언어 변경 | 이어하기 카드의 난이도 이름이 새 언어로 표시(스크린샷) | |
| 16 | 기록 화면 날짜 | 월·일 표기가 자연스러움(es 약어 점 등, 스크린샷) | |
| 17 | 이어하기 진행률 %, fr·es | 숫자와 % 사이 공백이 자연스러움(스크린샷) | |
| 18 | 기기 언어 `sw` / `zh-Hant` / `zh-TW` / `fr-CA` / `no` | en / 번체 / 번체 / fr / nb | |
| 19 | 프랑스어 기기에서 첫 실행 | ATT 창 문구가 프랑스어, UMP 폼 언어는 D3 설정에 따름 | |
| 20 | 320pt 폭 기기(iPhone SE 1세대급), de·ru·pt | 홈·게임·결과 시트·설정에서 글자 잘림이나 겹침 없음 | |
| 21 | 33개 밖의 표시 언어 기기 첫 실행 | 그런 표시 언어가 있으면 그것으로 확인(ATT 창·앱이 영어), 없으면 N/A. ATT 폴백은 `ios_config_test`, Flutter 폴백은 Android `sw`로 확인 | |
| 22 | `ar` | 숫자패드 1~9 왼쪽→오른쪽, 스탯 칩 오른쪽 정렬, 뒤로 화살표 반전, 보드는 그대로 | |
| 23 | `th`·`hi` | 글리프 잘림·□ 없음 | |
| 24 | `de` | 결과 시트(320pt 포함) 라벨 한 줄 | |
| 25 | `ru` | 실수 1/2/5/21 형태가 자연스러움 | |
| 26 | `zh-Hant` | 번체로 표시 | |
| 27 | 설정 > 개인정보처리방침 | 외부 브라우저에서 로그인 없이 열리고, 복귀하면 설정 화면이 그대로 | |
| 28 | iOS 무음 스위치 ON에서 게임 입력 | 효과음이 나지 않음 | |
| 29 | 음악 앱이 재생 중일 때 보드·숫자패드 탭 | 음악이 끊기지 않고 효과음이 섞여 남 | |
| 30 | 통화·Siri 뒤, 전면광고를 닫은 뒤 첫 탭 | 소리가 정상 | |
| 31 | 콜드스타트 직후 첫 탭 | 크래시 없음, 소리가 남 | |
| 32 | 보상형 힌트: 무료 3회 소진 후 광고를 끝까지 시청 / 중간에 닫음 / iOS에서 광고 중 타이머 | 끝까지 보면 힌트 1회 지급(칸이 채워짐), 중간에 닫거나 실패하면 지급 없이 스낵바. 광고 중 타이머 정지 | |
| 33 | 실수 5회 → '광고 보고 이어서 도전' | 광고 시청 후 실수 0/5로 계속, 보드·타이머 유지. 광고 취소 시 시트가 남고 버튼 재활성. 다시 5회면 또 이어 도전 가능 | |
| 34 | 광고 제거 사용자: 힌트·이어 도전 | 힌트 무제한(광고 없음), 이어 도전 즉시(광고 없음) | |
| 35 | 주간 대결 1등 클리어(닉네임 없음) | 결과 시트에서 닉네임 다이얼로그 1회 자동 표시 → 입력하면 주간 화면 1등 카드에 닉네임·시간 표시 | |
| 36 | 비행기 모드에서 주간 퍼즐 클리어 → 비행기 모드 해제 | 기록이 대기열에 남았다가 연결 후 재전송되어 순위표에 반영 | |
| 37 | 앱 재설치 후 주간 대결 | Android는 새 익명 uid(이전 기록과 별개), iOS는 Keychain 때문에 같은 uid일 수 있음(알려진 한계). 크래시 없음 | |
| 38 | 월요일 09:00 KST 경계(08:59 → 09:00) | 09:00 이후 새 주 보드(`YYYY-Www` 증가)와 새 퍼즐, 이전 주 기록은 새 보드에 보이지 않음 | |
| 39 | `ar`·`he`·`th`·`hi` 닉네임 입력 | 2~12자 검증 통과(결합 문자 허용), RTL 표시 정상, 1등 카드·결과 시트에서 잘림 없음 | |
| 40 | **[R]** 중급 Android 실기기(release 빌드)에서 지옥 주간 시드 첫 생성 | 생성 시간 측정(ms) 후 README 시드 생성 실측표 합격선과 비교(개발 PC JIT 최댓값 ≤ 400ms × 약 4배 ≈ 1.6초). 준비 화면이 닫히고, 두 번째 진입 시 캐시로 즉시 시작. 측정값·기기명을 결과 칸과 README에 기록 | |

- 수동 QA 언어 전환은 iOS 설정 > Sudoku > 언어(앱별 언어)로 대표 6개(`de, ru, ar, th, zh-Hant, sw→en`)를 바꿔 가며 합니다.
- **iOS 기대값**: 언어를 바꾸면 앱이 다시 시작되고 → 이어하기 카드가 보이고 → 저장한 상태로 복원됩니다. "보드·타이머 유지"는 Android 기대값입니다(Manifest `configChanges`에 `locale|layoutDirection`).

게임 중 언어 변경 시 상태 유지와 폴백·해석 규칙은 `test/l10n/locale_test.dart`가, 360dp·1.3배 글자·320dp(de·ru·pt·fr·ar) overflow는 `test/l10n/layout_test.dart`가 검증합니다. 글자 잘림은 실폰트 수동 캡처로만 판정합니다.

15분 경계(14:59/15:00)와 시계 역행은 `test/services/ad_schedule_test.dart`가 검증합니다.

주간 경계(UTC 월 00:00 = KST 월 09:00)·주간 퍼즐 캐시·순위 정책·닉네임 검증은 `test/services/weekly`(Firestore 규칙 자체는 H6 Playground로만 확인), 일일 힌트 한도는 `test/services/hint_budget_test.dart`가 검증합니다. 32~40은 E5·H 완료 후에만 실행할 수 있습니다(그 전에는 보상형이 `unavailable`, 주간 대결이 숨겨짐).

UMP 갱신 무응답 시나리오는 실기기에서 재현할 수 없으므로 단위 테스트(`test/services/consent_service_test.dart`)로 대신합니다.

## 블록별 남은 개수 (2026-10-29)

| 블록 | 남음 / 전체 |
|---|---|
| A | 5 / 13 |
| B | 4 / 4 (Android 보류) |
| C | 8 / 8 (Android 보류) |
| D | 2 / 4 |
| E | 3 / 6 |
| F | 11 / 12 |
| G | 4 / 5 |
| H | 12 / 12 |
