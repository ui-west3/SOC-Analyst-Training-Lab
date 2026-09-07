#!/bin/bash
# Nmap recon workflow
# Usage: ./nmap-scan.sh <target>

set -e

TARGET="$1"
if [ -z "$TARGET" ]; then
  echo "Usage: $0 <target>"
  exit 1
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_DIR="reports/$STAMP"
mkdir -p "$OUT_DIR"

echo "[*] SYN scan..."
nmap -sS -Pn "$TARGET" -oN "$OUT_DIR/syn-scan.txt"

echo "[*] Service detection..."
nmap -sV "$TARGET" -oN "$OUT_DIR/service-detection.txt"

echo "[*] Full output bundle..."
nmap -sS -sV -oA "$OUT_DIR/full-scan" "$TARGET"

echo "[+] Reports saved to: $OUT_DIR"
