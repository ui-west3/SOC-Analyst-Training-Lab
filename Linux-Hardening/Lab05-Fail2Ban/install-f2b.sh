#!/bin/bash
set -e

echo "[*] Installing Fail2Ban..."
sudo apt update
sudo apt install -y fail2ban

echo "[*] Copying jail.local..."
sudo cp jail.local /etc/fail2ban/jail.local

echo "[*] Restarting and enabling service..."
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

echo "[*] Checking status..."
sudo fail2ban-client status
sudo fail2ban-client status sshd

echo "[+] Done."
