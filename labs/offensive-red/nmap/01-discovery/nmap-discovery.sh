#!/bin/bash
# Lab 01 — Host Discovery (Nmap series)
# TCP SYN ping on 22, 80, 443; no port scan (-sn).
# Matches video: sudo nmap -sn -PS22,80,443 <range>
#
# Usage:
#   chmod +x nmap-discovery.sh
#   sudo ./nmap-discovery.sh 10.10.10.0/24
#
# Output: live-hosts.txt in this directory (IPs only, one per line).

set -euo pipefail
TARGET="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="${SCRIPT_DIR}/live-hosts.txt"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target_or_range>"
    echo "Example: $0 10.10.10.0/24"
    exit 1
fi

if ! command -v nmap &>/dev/null; then
    echo "Error: nmap not installed. Run: sudo apt install nmap"
    exit 1
fi

# Prefer root for raw SYN / consistent behaviour with on-screen demos
if [[ "$(id -u)" -ne 0 ]]; then
    echo "[!] Tip: run with sudo for the same behaviour as in the lab video (e.g. sudo $0 $TARGET)"
fi

echo "[*] Target: $TARGET"
echo "[*] Host discovery: TCP SYN ping on ports 22, 80, 443 (-sn -PS)..."
# awk only: avoids grep exit code 1 when zero hosts (would break set -e)
nmap -sn -PS22,80,443 "$TARGET" -oG - | awk '/Status: Up/ { print $2 }' | tee "$OUT"
echo "[*] Live hosts saved to: $OUT"
