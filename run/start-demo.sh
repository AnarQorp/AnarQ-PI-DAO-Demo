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

# 2) Arrancar orquestador si existe
if [[ -x "$CORE_DIR/demo-orchestrator/start.sh" ]]; then
  echo "[*] Starting demo orchestrator..."
  ( cd "$CORE_DIR/demo-orchestrator" && ./start.sh demo ) >"$LOG_DIR/orchestrator.log" 2>&1 &
  echo $! > "$WORK_DIR/orchestrator.pid"
  echo "  [+] Orchestrator pid $(cat "$WORK_DIR/orchestrator.pid")"
else
  echo "[!] demo-orchestrator/start.sh not found; continuing anyway."
fi

# 3) Buscar un frontend Vite válido (si hay) y servirlo en preview
VITE_DIR="$(find "$CORE_DIR" -type f -name 'vite.config.*' -printf '%h\n' | head -n1 || true)"
if [[ -n "$VITE_DIR" && -d "$VITE_DIR" ]]; then
  echo "[*] Building frontend at $VITE_DIR ..."
  pnpm -C "$VITE_DIR" build || pnpm -C "$VITE_DIR" vite build
  echo "[*] Preview on http://localhost:$PORT ..."
  ( cd "$VITE_DIR" && pnpm preview --host --port "$PORT" ) >"$LOG_DIR/vite-preview.log" 2>&1 &
  echo $! > "$WORK_DIR/vite-preview.pid"
  echo "✅ UI at http://localhost:$PORT"
else
  echo "[!] No Vite project found. The demo may expose its UI from the orchestrator or another service."
fi

echo "Logs at: $LOG_DIR"

