#!/usr/bin/env bash
set -euo pipefail
CORE_URL="${CORE_URL:-https://github.com/AnarQorp/anarqq-ecosystem-core.git}"
CORE_REF="${1:-main}"
WORK_DIR="${WORK_DIR:-.work}"
CORE_DIR="$WORK_DIR/core"

echo "[*] Using CORE_URL=$CORE_URL @ $CORE_REF"
mkdir -p "$WORK_DIR"

if [[ -d "$CORE_DIR/.git" ]]; then
  echo "[*] Core already present, fetching updates..."
  ( cd "$CORE_DIR" && git fetch --depth=1 origin "$CORE_REF" && git reset --hard "origin/$CORE_REF" ) || {
    echo "[!] Could not fast-fetch; falling back to fresh clone..."
    rm -rf "$CORE_DIR"
    git clone --depth=1 --branch "$CORE_REF" "$CORE_URL" "$CORE_DIR"
  }
else
  echo "[*] Cloning core..."
  git clone --depth=1 --branch "$CORE_REF" "$CORE_URL" "$CORE_DIR"
fi

echo "[*] Looking for demo installers in core..."
shopt -s nullglob
found_any=0
for f in \
  "$CORE_DIR"/install-anarqq-demo.sh \
  "$CORE_DIR"/install-anarqq-demo.ps1 \
  "$CORE_DIR"/install-anarqq-demo.py \
  "$CORE_DIR"/anarqq-ecosystem-demo-installers-*.zip \
  "$CORE_DIR"/anarqq-ecosystem-demo-installers-*.tar.gz
do
  if [[ -e "$f" ]]; then
    echo "  [+] Found: $(basename "$f")"
    cp -f "$f" .
    found_any=1
  fi
done
shopt -u nullglob

if [[ "$found_any" -eq 0 ]]; then
  echo "[!] No installer artifacts found (OK). We'll install via pnpm directly from the core."
fi

echo "[*] Done. Next: bash run/start-demo.sh"

