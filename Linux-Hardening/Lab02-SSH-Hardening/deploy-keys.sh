#!/bin/bash

# --- CONFIGURATION ---
CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"

echo "[INFO] Starting Lab02: SSH Security Hardening..."

# 1. Backup existing configuration
if [ ! -f "$BACKUP_FILE" ]; then
    sudo cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo "[SUCCESS] Backup created at $BACKUP_FILE"
else
    echo "[INFO] Backup already exists. Skipping..."
fi

# 2. Hardening: Disable Password Authentication
# We use 'sed' to find and replace the line, or add it if missing
sudo sed -i 's/#\?PasswordAuthentication .*/PasswordAuthentication no/' "$CONFIG_FILE"
echo "[INFO] Password authentication: DISABLED"

# 3. Hardening: Disable Root Login (Prohibit Password)
sudo sed -i 's/#\?PermitRootLogin .*/PermitRootLogin prohibit-password/' "$CONFIG_FILE"
echo "[INFO] Direct Root login: RESTRICTED"

# 4. Configuration Check (Syntax Test)
echo "[INFO] Testing SSH configuration syntax..."
if sudo sshd -t; then
    echo "[SUCCESS] Syntax is correct. Restarting SSH service..."
    sudo systemctl restart ssh
else
    echo "[ERROR] SSH syntax error detected! Restoring from backup..."
    sudo cp "$BACKUP_FILE" "$CONFIG_FILE"
    exit 1
fi

# 5. Final Verification
echo "--------------------------------------"
echo "[DONE] SSH is now secured."
sudo systemctl status ssh | grep Active
echo "--------------------------------------"
