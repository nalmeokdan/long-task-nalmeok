# longtask

> super high-volume 작업을 Agent에게 체계적으로 위임하기 위한 Claude Code 플러그인.

## 왜

큰 작업은 처음부터 전부 계획할 수 없다. context를 한 번에 머릿속에 담을 수 없어 미리 짠 계획은
진행 중 거의 반드시 깨지고, 세션은 휘발성이라 매 시작마다 맥락을 잃는다.

longtask는 이 둘을 정면으로 다룬다 — **거칠게 쪼개 앞으로도 안 깨질 경계만 긋고**, **읽기 비용이
작업 크기와 무관하게 일정한 장기메모리**로 세션 간 맥락을 잇는다.

## 설치

```
/plugin marketplace add nalmeokdan/long-task-nalmeok
/plugin install longtask@longtask
```

## 명령어

| 명령 | 하는 일 |
|------|---------|
| `/longtask:grill [한 줄 설명]` | 모호한 요구사항을 deep interview로 태워 없애고 정확한 spec으로 확정한다. |
| `/longtask:divide [대상]` | 대상 작업을 **한 단계만** 거칠게 분해한다. |
| `/longtask:status` | 메모리를 가볍게 훑어 "지금 어디까지 왔고 다음에 뭘 할 차례인지" 짚어준다. |
| `/longtask:update-memory [세션 요약]` | 이번 세션의 결정·실패·발견을 장기메모리에 반영한다. |

> 메모리 쓰기는 **`update-memory`를 명시적으로 호출할 때만** 일어난다. 분해·진행 결과를 저장하려면 직접 부른다 — 시키지 않은 자동 적재는 하지 않는다.

## 장기메모리 — `.longtask/`

작업 대상 워크스페이스 루트에 생기며 **프로젝트마다 독립**이다(한 작업의 진행도가 다른 곳으로
새지 않는다). 핵심 설계는 *읽기 비용* — 작업이 아무리 커져도 한 세션이 자기 위치를 파악하는
비용이 일정하도록 국소적으로만 읽힌다.

```
.longtask/
  charter.md       목표·범위·제약·수용기준 (거의 불변, 모든 세션의 north star)
  map.md           노드 트리 + 상태 (진행도의 single source of truth)
  lessons.md       전역 교훈/규약
  nodes/<id>/      노드별 작업기록(append-only)·종결요약(완료 시)
  archive/<id>/    닫힌 노드의 원본 (hot 경로 밖, 영구 보존)
```

## 전형적 흐름

1. `/longtask:grill` — 무엇을 만들지 못 박는다.
2. `/longtask:divide` — 한 단계 쪼갠다. frontier 노드를 다시 `divide`하며 필요한 만큼 내려간다.
3. 구현 세션을 연다 — 시작 시 `/longtask:status`로 위치를 잡고, 끝에 `/longtask:update-memory`로 남긴다.
4. 전체가 끝날 때까지 2–3을 반복한다.

## 설계 원칙

- **확정성 > 완전성.** 추측으로 미래를 채우지 않는다. 지금 확실히 긋고 앞으로도 안 바뀔 경계만 긋는다.
- **한 번에 한 단계.** divide는 한 레벨만 나누고 멈춘다. 세부는 의도적으로 나중으로 미룬다.
- **읽기 비용으로 메모리를 설계한다.** 상태는 덮어쓰고, 사건(특히 실패한 막다른 길)은 쌓는다.
