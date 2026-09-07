#!/bin/bash
# Nmap SYN Scan — nmap/02-syn-scan
# Usage: ./nmap-syn-scan.sh <target>

set -e
TARGET="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target>"
    echo "Example: $0 10.10.10.5"
    exit 1
fi

if ! command -v nmap &>/dev/null; then
    echo "Error: nmap not installed. Run: sudo apt install nmap"
    exit 1
fi

echo "[*] Target: $TARGET"
echo "[*] Running SYN scan (-sS -Pn)..."
nmap -sS -Pn "$TARGET" -oN "$SCRIPT_DIR/syn-scan.txt"
echo "[*] Report saved to: $SCRIPT_DIR/syn-scan.txt"
