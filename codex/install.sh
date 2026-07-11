#!/usr/bin/env bash
# longtask → OpenAI Codex 설치.
# 각 command를 Codex 스킬로 ~/.codex/skills/ 에 깐다. 방법론 원본(../methods)은
# 단일 소스 — 여기서 각 스킬의 references/ 로 주입한다(중복 소스 없음).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${CODEX_HOME:-$HOME/.codex}/skills"

install_skill() {
  skill="$1"; method="$2"
  out="$DEST/$skill"
  mkdir -p "$out/references"
  cp "$ROOT/codex/skills/$skill/SKILL.md" "$out/SKILL.md"
  cp "$ROOT/methods/$method.md" "$out/references/$method.md"
  echo "installed: $out"
}

# skill                     참조 method
install_skill longtask-grill         how-to-grill
install_skill longtask-divide        how-to-divide
install_skill longtask-status        how-to-manage-memory
install_skill longtask-update-memory how-to-manage-memory

echo "완료. Codex를 새로 열고 /skills 에서 longtask-* 를 확인한다."
