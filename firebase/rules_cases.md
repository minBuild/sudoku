# Firestore 규칙 Playground 케이스 (체크리스트 H6)

대상 규칙: [`firestore.rules`](firestore.rules). Firebase 콘솔 > Firestore > 규칙 > Rules Playground에서 실행하고 결과 칸에 `allow`/`deny`와 실행일을 적습니다.

**상태: 미실행**(2026-10-29, 콘솔 작업 미완료. 브라우저가 연결되지 않음)

## 준비

- 보드 `2026-W44_hard_g1`에 문서 `weekly/2026-W44_hard_g1/entries/uidA`를 콘솔에서 미리 만듭니다: `ms`=120000(int), `nick`="Alpha", `hintUsed`=false, `v`=1(int), `updatedAt`=(timestamp), `expireAt`=(timestamp). 업데이트 케이스(2·3·5)는 이 문서를 기준으로 합니다. 확인이 끝나면 이 문서를 지웁니다(콘솔 삭제는 규칙과 무관).
- "인증"이 `uidA`이면 Playground의 Authenticated를 켜고 Firebase UID에 `uidA`를 넣습니다.
- 기본 데이터(아래 "유효")는 `ms`=100000(int), `nick`="Alpha", `hintUsed`=false, `v`=1(int), `updatedAt`=요청 시각(timestamp), `expireAt`=(timestamp)입니다.
- 규칙은 `updatedAt == request.time`을 요구합니다. Playground에서 서버 시각(serverTimestamp)을 지정할 수 없어 allow 케이스(1~3)가 `deny`로 나오면, 결과 칸에 그 사실을 적고 실기기 확인(체크리스트 H9)으로 대신합니다. 규칙을 고쳐서 통과시키지 않습니다.

## 케이스

| # | 케이스 | 경로 | 인증 | 데이터 | 기대 | 결과 | 실행일 |
|---|---|---|---|---|---|---|---|
| 1 | 본인 기록 생성 | `create` `weekly/2026-W44_hard_g2/entries/uidA` (새 보드, 문서 없음) | uidA | 유효 | allow | 미실행 | |
| 2 | 더 빠른 기록으로 갱신 | `update` `weekly/2026-W44_hard_g1/entries/uidA` | uidA | 유효, `ms`=100000 (기존 120000보다 작음) | allow | 미실행 | |
| 3 | 닉네임만 변경 | `update` `weekly/2026-W44_hard_g1/entries/uidA` | uidA | 기존과 같고 `nick`="Beta", `updatedAt`만 바뀜 (`ms`=120000 유지) | allow | 미실행 | |
| 4 | 다른 사람 uid에 쓰기 | `create` `weekly/2026-W44_hard_g2/entries/uidB` | uidA | 유효 | deny | 미실행 | |
| 5 | 더 느린 기록으로 갱신 | `update` `weekly/2026-W44_hard_g1/entries/uidA` | uidA | 유효, `ms`=150000 (기존보다 큼), `nick` 그대로 | deny | 미실행 | |
| 6 | 허용되지 않은 필드 추가 | `create` `weekly/2026-W44_hard_g2/entries/uidA` | uidA | 유효 + `score`=1 | deny | 미실행 | |
| 7 | 힌트 사용 기록 | `create` `weekly/2026-W44_hard_g2/entries/uidA` | uidA | 유효, `hintUsed`=true | deny | 미실행 | |
| 8 | 시간 범위 밖 | `create` `weekly/2026-W44_hard_g2/entries/uidA` | uidA | 유효, `ms`=5000 (< 10000) | deny | 미실행 | |
| 9 | 비로그인 쓰기 | `create` `weekly/2026-W44_hard_g2/entries/uidA` | 없음 | 유효 | deny | 미실행 | |
| 10 | 삭제 | `delete` `weekly/2026-W44_hard_g1/entries/uidA` | uidA | - | deny | 미실행 | |

- allow 3개(1~3), deny 7개(4~10).
- 8번은 `ms`=86400001(> 24시간)로도 한 번 더 확인하면 좋습니다(선택).
- 결과가 기대와 다르면 규칙을 게시하지 말고 원인을 README §Firebase에 기록합니다.
