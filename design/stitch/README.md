# 스도쿠 — Stitch 디자인

- Stitch 프로젝트: **sudoku** (`projects/7095076129913526290`, ID `7095076129913526290`)
- 디자인 시스템: **Mindful Indigo Sudoku** (`assets/f2d4dee9055f462ba13cc7cc955b0adc`)
- 기기: MOBILE, 라이트 테마만
- 파일 목록은 `screens.json`. 다운로드는 Pocket-Dev 가 `<slug>.html` · `<slug>.png` 로 저장한다.

> 참고: TASK_SPEC.md 는 AdMob ID 반영 작업이라 UI 변경이 없다. 화면은 기존 앱(2.0 리디자인)의 사용자 화면을 `lib/screens`, `lib/widgets`, `lib/l10n/strings.dart` 기준으로 디자인했다.
> 광고 자체(전면광고)는 AdMob 이 그리므로 별도 화면이 없다.

## 화면 목록

| slug | 역할 | Stitch screen ID |
|---|---|---|
| `home` | 홈. 로고·태그라인, 진행 중인 게임 카드, 새 게임/기록/설정, 광고 제거 카드 | `7d1e5719a3f74f299e23946697eeb7a6` |
| `difficulty-sheet` | 난이도 선택 바텀시트 (쉬움/보통/어려움/전문가) | `0598483243c24cbcbc38cc59648d08ad` |
| `game` | 게임 화면. 스탯 칩, 9x9 보드, 툴바(되돌리기/지우기/메모), 숫자 패드 | `b0508aa3a6be4563ab031f0fbd155032` |
| `result-sheet` | 클리어 결과 시트. 시간·실수·난이도, 광고 제거 유도, 새 게임/홈 | `1ddcb3551ab3471cad29c4c1c2b376e8` |
| `records` | 기록. 난이도 필터, 최고 기록, 최근 기록 목록 | `67cfd91658fe4217bb6490ceed4d6b9e` |
| `settings` | 설정. 즉시 체크 기본값, 광고 제거·구매 복원, 개인정보 옵션, 앱 버전 | `f5d71871e7a44026aa46f5c8b7ae90ca` |

### 구현 시 주의 (생성물과 실제 앱의 차이)
Stitch 가 임의로 덧붙인 요소는 구현하지 않는다: 하단 탭 바(홈/통계/데일리/설정), 연속 일수 "5일 연속", 힌트 버튼, 점수·XP, 타이머 표시 등 추가 토글. 실제 기능과 문구는 `lib/l10n/strings.dart` 를 따른다.

## 디자인 토큰
값은 `lib/theme/app_theme.dart` 와 같다 (Stitch 시스템의 Material 이름 색은 약간 달라도 아래 값 기준).

### 색
| 토큰 | 값 |
|---|---|
| 배경 canvas | `#F5F6FA` |
| 표면 surface (카드) | `#FFFFFF` |
| primary | `#3B5BDB` (pressed `#2F49B0`) |
| primary tint | `#EDF2FF` (pressed `#DBE4FF`) |
| secondary | `#748FFC` |
| 본문 텍스트 | `#1F2937` |
| 보조 텍스트 | `#6B7280` |
| 테두리 | `#E5E7EB` (3x3 블록 경계 `#CBD5E1`) |
| 오류/충돌 | `#E5484D` / 셀 `#FA5252` on `#FFE3E3` |
| 경고 | `#F59F00` |
| 스크림 | `#0F172A` 30% |

보드: 선택 셀 `#3B5BDB` + 흰 숫자, 연관 행/열/박스 `#EDF2FF`, 같은 숫자 `#DBE4FF`, 주어진 숫자 `#1F2937` 700, 입력 숫자 `#3B5BDB` 600, 메모 `#6B7280` 10px.

### 글꼴
Noto Sans (한글 Noto Sans KR / Pretendard 호환), 숫자는 tabular figures.

| 스타일 | 크기/굵기 |
|---|---|
| displaySmall | 32 / 700 |
| headline-lg / medium | 30 / 700, 24 / 700 (화면 제목) |
| headline-sm / title | 18 / 600, 16 / 600 |
| body | 16 / 14 |
| bodySmall | 12, 보조색 |
| label | 14 / 600, 12 / 500 |
| 보드 숫자 / 메모 | 24 / 600, 10 / 500 |

### 간격·형태
- 페이지 좌우 패딩 20, 최대 콘텐츠 폭 480, 간격 단위 4 (4·8·12·20·28)
- 카드 radius 16, 버튼 radius 14 (최소 높이 48), 키패드 12, 시트 상단 24, 칩 pill
- 그림자: `0 2 4 rgba(31,41,55,.03)` + `0 10 24 -4 rgba(59,91,219,.06)`; 시트/모달은 `0 12 32 -4 rgba(31,41,55,.12)`
- 3x3 블록 경계 2px, 셀 경계 1px
