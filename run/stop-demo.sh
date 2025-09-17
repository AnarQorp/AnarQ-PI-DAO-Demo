#!/usr/bin/env bash
set -euo pipefail

echo "[*] Stopping AnarQ demo processes..."

# Kill vite/dev servers running on port 4173 (Qsocial)
if lsof -ti:4173 >/dev/null 2>&1; then
  lsof -ti:4173 | xargs kill -9 || true
  echo "  [+] Stopped process on port 4173"
fi

# Kill pnpm dev processes
pkill -f "pnpm.*dev" >/dev/null 2>&1 && echo "  [+] Stopped pnpm dev" || true

# Kill node processes running dist/server (production build)
pkill -f "node.*dist" >/dev/null 2>&1 && echo "  [+] Stopped node server" || true

echo "[*] Done. Demo stopped."

