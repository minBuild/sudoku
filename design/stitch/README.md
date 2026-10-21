# 스도쿠 — Stitch 디자인

- Stitch 프로젝트: **sudoku** (`projects/5856333340112223540`, ID `5856333340112223540`)
- 디자인 시스템: **Jeonggwan Sudoku** (`assets/215acad3741e43c5bcde73195f604b16`)
- 기기: MOBILE, 라이트 테마만
- 파일 목록은 `screens.json`. 다운로드는 Pocket-Dev 가 `<slug>.html` · `<slug>.png` 로 저장한다.

> 참고: TASK_SPEC.md 는 AdMob ID 반영·출시 준비 작업이라 UI 변경이 없다. 화면은 기존 앱(2.0 리디자인)의 사용자 화면을 기준으로 디자인했다.
> 광고 자체(전면광고)는 AdMob 이 그리므로 별도 화면이 없다.

## 화면 목록

| slug | 역할 | Stitch screen ID |
|---|---|---|
| `home` | 홈. 로고·태그라인, 이어하기 카드, 새 게임/기록/설정, 광고 제거 카드 | `d46f8c8c776a4a289f7dd6678a0e0dc8` |
| `difficulty-sheet` | 난이도 선택 바텀시트 (쉬움/보통/어려움/전문가) | `90cb0f08560f48f8871cbc2884b62661` |
| `game` | 게임 화면. 스탯 칩, 9x9 보드, 툴바(되돌리기/지우기/메모), 숫자 패드 | `0ca1a247e2514168b32e858fd89ab982` |
| `result-sheet` | 클리어 결과 시트. 시간·실수·난이도·최고 기록, 광고 제거 유도, 새 게임/홈 | `f0563aabd71a4ca4a1f7ff5383dc841c` |
| `records` | 기록. 난이도 필터, 최고 기록, 최근 기록 목록 | `74e869d08f45486283bef993ab7c60c7` |
| `settings` | 설정. 즉시 체크, 광고 제거·구매 복원, 개인정보 옵션, 앱 버전 | `ff7bd330adc74f36a11c568f1e3cd157` |

### 구현 시 주의 (생성물과 실제 앱의 차이)
- **가격 숫자는 구현하지 않는다.** `settings` 화면의 "₩4,900" 은 Stitch 가 임의로 넣은 값이다. 실제 앱은 스토어의 `ProductDetails.price` 만 표시한다(TASK_SPEC D17).
- Stitch 가 임의로 덧붙인 요소는 구현하지 않는다: 일시정지 버튼, 잔여 개수 배지, 승률, "숫자 중복 강조"·"자동 메모 정리"·이용약관·문의하기 항목, PRO 배지, 공유/XP 류.
- 실제 기능과 문구는 `lib/l10n/strings.dart` 를 따른다.

## 디자인 토큰
값은 `lib/theme/app_theme.dart` 와 같다 (Stitch 시스템의 Material 이름 색은 약간 달라도 아래 값 기준).

### 색
| 토큰 | 값 |
|---|---|
| 배경 canvas | `#F5F6FA` |
| 표면 surface (카드) | `#FFFFFF` |
| primary | `#3B5BDB` (pressed `#2F4BC4`) |
| primary tint | `#EDF2FF` (같은 숫자 `#DBE4FF`) |
| 본문 텍스트 | `#1F2937` |
| 보조 텍스트 | `#6B7280` |
| 테두리 | `#E5E7EB` |
| 오류/충돌 | 숫자 `#FA5252` on `#FFE3E3` |
| 완료 | `#12B886` |
| 스크림 | `#0F172A` 30% |

보드: 선택 셀 `#3B5BDB` + 흰 숫자, 연관 행/열/박스 `#EDF2FF`, 같은 숫자 `#DBE4FF`, 주어진 숫자 `#1F2937` 굵게, 입력 숫자 `#3B5BDB`, 메모 `#6B7280` 10px.

### 글꼴
Noto Sans (한글 Noto Sans KR), 숫자는 tabular figures.

| 스타일 | 크기/굵기 |
|---|---|
| headline-lg(-mobile) | 32 / 700 (26 / 700) |
| headline-md | 22 / 600 |
| headline-sm | 18 / 600 |
| body-lg / md / sm | 16 / 500, 14 / 400, 12 / 400 |
| label-lg / md / sm | 15 / 600, 13 / 500, 11 / 500 |
| 보드 숫자 / 메모 | 24 / 500~600, 10 / 400 |

### 간격·형태
- 페이지 좌우 패딩 20, 간격 단위 4 (4·8·12·16·20·24), gutter 12
- 카드·보드 radius 16, 버튼·키패드 radius 14 (최소 높이 48), 시트 상단 24, 칩 pill
- 카드 그림자 `0 4 16 -2 rgba(0,0,0,.05)`, 3x3 블록 경계 2px, 셀 경계 1px
