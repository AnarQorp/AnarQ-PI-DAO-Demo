#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="${WORK_DIR:-.work}"

echo "[*] Stopping AnarQ&Q Demo..."

# Stop backend
if [[ -f "$WORK_DIR/backend.pid" ]]; then
  kill "$(cat "$WORK_DIR/backend.pid")" 2>/dev/null || true
  rm -f "$WORK_DIR/backend.pid"
  echo "  [+] Backend stopped"
fi

# Stop frontend
if [[ -f "$WORK_DIR/frontend.pid" ]]; then
  kill "$(cat "$WORK_DIR/frontend.pid")" 2>/dev/null || true
  rm -f "$WORK_DIR/frontend.pid"
  echo "  [+] Frontend stopped"
fi

# Kill any leftover processes
if lsof -ti:3002 >/dev/null 2>&1; then
  lsof -ti:3002 | xargs kill -9 || true
fi

if lsof -ti:4173 >/dev/null 2>&1; then
  lsof -ti:4173 | xargs kill -9 || true
fi

echo "✅ All services stopped."