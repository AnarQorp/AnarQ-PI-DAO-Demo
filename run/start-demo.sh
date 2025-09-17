#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="${WORK_DIR:-.work}"
CORE_DIR="$WORK_DIR/core"

if [[ ! -d "$CORE_DIR" ]]; then
  echo "[!] Core not found. Run: bash bootstrap/fetch-core-demo.sh"
  exit 1
fi

echo "[*] Installing dependencies..."
cd "$CORE_DIR"
pnpm install

echo "[*] Building demo (with mocks + Qsocial as entrypoint)..."
pnpm --filter @anarq/qsocial build

echo "[*] Starting demo server..."
pnpm --filter @anarq/qsocial dev --host --port 4173

