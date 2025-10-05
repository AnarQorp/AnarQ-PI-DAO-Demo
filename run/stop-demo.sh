#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="${WORK_DIR:-.work}"

echo "[*] Stopping demo..."

# Stop backend
if [[ -f "$WORK_DIR/backend.pid" ]]; then
  kill "$(cat "$WORK_DIR/backend.pid")" 2>/dev/null || true
  rm -f "$WORK_DIR/backend.pid"
  echo "  [+] Backend stopped"
fi

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

# Kill any leftover processes on ports
if lsof -ti:4173 >/dev/null 2>&1; then
  lsof -ti:4173 | xargs kill -9 || true
fi

if lsof -ti:3001 >/dev/null 2>&1; then
  lsof -ti:3001 | xargs kill -9 || true
fi

echo "✅ Done."

