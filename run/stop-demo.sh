#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="${WORK_DIR:-.work}"

echo "[*] Stopping demo..."

# Stop orchestrator
if [[ -f "$WORK_DIR/orchestrator.pid" ]]; then
  kill "$(cat "$WORK_DIR/orchestrator.pid")" 2>/dev/null || true
  rm -f "$WORK_DIR/orchestrator.pid"
  echo "  [+] Orchestrator stopped"
fi

# Stop vite preview
if [[ -f "$WORK_DIR/vite-preview.pid" ]]; then
  kill "$(cat "$WORK_DIR/vite-preview.pid")" 2>/dev/null || true
  rm -f "$WORK_DIR/vite-preview.pid"
  echo "  [+] Vite preview stopped"
fi

# Kill any leftover on 4173
if lsof -ti:4173 >/dev/null 2>&1; then
  lsof -ti:4173 | xargs kill -9 || true
fi

echo "✅ Done."

