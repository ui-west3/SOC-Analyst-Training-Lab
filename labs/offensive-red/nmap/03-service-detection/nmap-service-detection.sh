#!/bin/bash
# Nmap Service Detection — nmap/03-service-detection
# Usage: ./nmap-service-detection.sh <target>

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
echo "[*] Running service/version detection (-sV)..."
nmap -sV "$TARGET" -oN "$SCRIPT_DIR/service-detection.txt"
echo "[*] Report saved to: $SCRIPT_DIR/service-detection.txt"
