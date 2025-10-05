#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="${WORK_DIR:-.work}"
CORE_DIR="$WORK_DIR/core"
LOG_DIR="$WORK_DIR/logs"
PORT="${PORT:-4173}"   # Puerto de preview si hay frontend Vite
mkdir -p "$LOG_DIR"

if [[ ! -d "$CORE_DIR" ]]; then
  echo "[-] Core not found. Run: bash bootstrap/fetch-core-demo.sh <branch-or-tag>"
  exit 1
fi

echo "[*] Preparing Node + pnpm"
if ! command -v corepack >/dev/null 2>&1; then
  echo "[!] corepack not found. Install Node.js >= 18 first."; exit 1
fi
corepack enable >/dev/null 2>&1 || true
corepack prepare pnpm@9 --activate

echo "[*] Installing core deps (skip Electron binary download)"
export ELECTRON_SKIP_BINARY_DOWNLOAD=1
pnpm -C "$CORE_DIR" install

# 1) Si existen instaladores de la demo, ejecútalos (modo demo)
if [[ -x "$CORE_DIR/install-anarqq-demo.sh" ]]; then
  echo "[*] Running core installer (demo mode)..."
  ( cd "$CORE_DIR" && ./install-anarqq-demo.sh ) | tee "$LOG_DIR/installer.log"
else
  echo "[!] No install-anarqq-demo.sh found (OK)."
fi

# 2) Arrancar backend
if [[ -f "$CORE_DIR/backend/package.json" ]]; then
  echo "[*] Starting backend server..."
  # Install backend dependencies if needed
  if [[ ! -d "$CORE_DIR/backend/node_modules" ]]; then
    echo "  [+] Installing backend dependencies..."
    pnpm -C "$CORE_DIR/backend" install
  fi
  
  # Start backend server
  ( cd "$CORE_DIR/backend" && pnpm start ) >"$LOG_DIR/backend.log" 2>&1 &
  echo $! > "$WORK_DIR/backend.pid"
  echo "  [+] Backend pid $(cat "$WORK_DIR/backend.pid")"
  echo "  [+] Backend running on http://localhost:3001"
else
  echo "[!] Backend package.json not found; continuing anyway."
fi

# 3) Arrancar orquestador si existe
if [[ -x "$CORE_DIR/demo-orchestrator/start.sh" ]]; then
  echo "[*] Starting demo orchestrator..."
  ( cd "$CORE_DIR/demo-orchestrator" && ./start.sh demo ) >"$LOG_DIR/orchestrator.log" 2>&1 &
  echo $! > "$WORK_DIR/orchestrator.pid"
  echo "  [+] Orchestrator pid $(cat "$WORK_DIR/orchestrator.pid")"
else
  echo "[!] demo-orchestrator/start.sh not found; continuing anyway."
fi

# 4) Find a valid Vite frontend (if any) and serve it in preview
# The main project is in the core directory with package.json
if [[ -f "$CORE_DIR/package.json" ]]; then
  echo "[*] Building frontend at $CORE_DIR ..."
  pnpm -C "$CORE_DIR" build
  echo "[*] Preview on http://localhost:$PORT ..."
  ( cd "$CORE_DIR" && pnpm preview --host --port "$PORT" ) >"$LOG_DIR/vite-preview.log" 2>&1 &
  echo $! > "$WORK_DIR/vite-preview.pid"
  echo "✅ UI at http://localhost:$PORT"
else
  echo "[!] No package.json found in core directory. The demo may expose its UI from the orchestrator or another service."
fi

echo "Logs at: $LOG_DIR"

