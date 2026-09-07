#!/bin/bash
# Nmap Output and Reporting — nmap/05-output-reporting
# Usage: ./nmap-output-reporting.sh <target>

set -e
TARGET="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_DIR="$SCRIPT_DIR/reports/$STAMP"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target>"
    echo "Example: $0 10.10.10.5"
    exit 1
fi

if ! command -v nmap &>/dev/null; then
    echo "Error: nmap not installed. Run: sudo apt install nmap"
    exit 1
fi

mkdir -p "$OUT_DIR"
echo "[*] Target: $TARGET"
echo "[*] Saving normal output..."
nmap -oN "$OUT_DIR/scan.txt" "$TARGET"

echo "[*] Saving full output bundle (-oA)..."
nmap -oA "$OUT_DIR/baseline" "$TARGET"

echo "[+] Reports saved to: $OUT_DIR"
