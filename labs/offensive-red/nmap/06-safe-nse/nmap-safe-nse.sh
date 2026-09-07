#!/bin/bash
# Nmap Safe NSE — nmap/06-safe-nse
# Usage: ./nmap-safe-nse.sh <target>

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
echo "[*] Running safe NSE scripts..."
nmap --script safe "$TARGET" -oN "$SCRIPT_DIR/safe-nse.txt"
echo "[*] Report saved to: $SCRIPT_DIR/safe-nse.txt"
