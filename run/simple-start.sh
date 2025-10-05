#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="${WORK_DIR:-.work}"
CORE_DIR="$WORK_DIR/core"
LOG_DIR="$WORK_DIR/logs"
mkdir -p "$LOG_DIR"

echo "[*] Starting AnarQ&Q Demo (Simple Mode)"

# 1) Start backend
echo "[*] Starting backend server..."
( cd "$CORE_DIR/backend" && pnpm start ) >"$LOG_DIR/backend.log" 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > "$WORK_DIR/backend.pid"
echo "  [+] Backend PID: $BACKEND_PID"

# Wait a bit for backend to start
sleep 5

# 2) Start frontend
echo "[*] Starting frontend..."
( cd "$CORE_DIR" && pnpm preview --host --port 4173 ) >"$LOG_DIR/frontend.log" 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > "$WORK_DIR/frontend.pid"
echo "  [+] Frontend PID: $FRONTEND_PID"

echo ""
echo "✅ Services started:"
echo "  🔧 Backend:  http://localhost:3002"
echo "  🌐 Frontend: http://localhost:4173"
echo ""
echo "📋 To stop: bash run/simple-stop.sh"
echo "📋 Logs at: $LOG_DIR"