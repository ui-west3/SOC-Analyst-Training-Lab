#!/bin/bash
# Nmap Speed vs Depth — nmap/04-speed-vs-depth
# Usage: ./nmap-speed-vs-depth.sh <target>

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
echo "[*] Running targeted scan (-p 22,80,443)..."
nmap -p 22,80,443 "$TARGET" -oN "$SCRIPT_DIR/targeted-ports.txt"

echo "[*] Running full port scan (-p-)..."
nmap -p- "$TARGET" -oN "$SCRIPT_DIR/full-ports.txt"

echo "[*] Reports saved:"
echo "    - $SCRIPT_DIR/targeted-ports.txt"
echo "    - $SCRIPT_DIR/full-ports.txt"
