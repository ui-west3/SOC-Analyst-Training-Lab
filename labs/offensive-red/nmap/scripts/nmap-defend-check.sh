#!/bin/bash
# Basic defensive host checks after scan activity

set -e

echo "[*] Listening services (ss):"
sudo ss -tulpen

echo
echo "[*] Firewall status (ufw):"
sudo ufw status verbose

echo
echo "[*] Pending package updates:"
sudo apt update -y >/dev/null 2>&1 || true
sudo apt list --upgradable 2>/dev/null || true

echo
echo "[+] Review open ports and disable unused services."
