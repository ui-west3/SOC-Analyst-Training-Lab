#!/bin/bash
set -e

echo "[*] Fail2Ban global status:"
sudo fail2ban-client status

echo
echo "[*] Fail2Ban sshd jail status:"
sudo fail2ban-client status sshd

echo
echo "[*] Recent Fail2Ban logs (30 min):"
sudo journalctl -u fail2ban --since "30 min ago" --no-pager
