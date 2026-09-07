#!/bin/bash

# 0. Root privilege check
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31m[!] Error: Please run as root: sudo ./setup-banners.sh\e[0m"
  exit
fi

# 1. Detect User Configuration (Zsh or Bash)
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(eval echo ~$REAL_USER)

if [ -f "$USER_HOME/.zshrc" ]; then
    CONF_FILE="$USER_HOME/.zshrc"
else
    CONF_FILE="$USER_HOME/.bashrc"
fi

echo -e "\e[34m[#] Initializing SOC Lab #3 for user: $REAL_USER\e[0m"
echo -e "\e[34m[#] Target configuration file: $CONF_FILE\e[0m"

# 2. SSH Banner Setup (tries: script dir, Desktop, Desktop .txt)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BANNER_PATH=""
for p in "$SCRIPT_DIR/mybanner" "$SCRIPT_DIR/mybanner.txt" "$USER_HOME/Desktop/mybanner" "$USER_HOME/Desktop/mybanner.txt"; do
    if [ -f "$p" ]; then
        BANNER_PATH="$p"
        break
    fi
done
if [ -n "$BANNER_PATH" ]; then
    echo -e "\e[32m[+] Deploying SSH Banner from $BANNER_PATH\e[0m"
    cp "$BANNER_PATH" /etc/issue.net
else
    echo -e "\e[33m[!] Warning: No banner file found (mybanner or mybanner.txt in script dir or Desktop). Skipping...\e[0m"
fi

# 3. SSH Hardening (Port 2222 & Banner Activation)
echo -e "\e[32m[+] Hardening SSH (Port 2222, Banner activation)...\e[0m"
# Update Port
sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config
sed -i 's/^Port 22/Port 2222/' /etc/ssh/sshd_config
# Update Banner path
sed -i 's/^#Banner none/Banner \/etc\/issue.net/' /etc/ssh/sshd_config
sed -i 's/^Banner .*/Banner \/etc\/issue.net/' /etc/ssh/sshd_config

# Apply changes
systemctl restart ssh
echo -e "\e[32m[+] SSH Service restarted successfully.\e[0m"

# 4. Injecting SOC Analyst Aliases
echo -e "\e[32m[+] Injecting SOC Aliases into $CONF_FILE...\e[0m"

if ! grep -q "SOC Analyst Tools" "$CONF_FILE"; then
cat <<EOT >> "$CONF_FILE"

# --- SOC Analyst Tools ---
# Quick Firewall Status
alias fw_status="sudo ufw status numbered"
# Real-time Attack Monitoring
alias check_attacks="sudo tail -f /var/log/auth.log | grep 'Failed password'"
# Fast SSH Config Access
alias ssh_conf="sudo nano /etc/ssh/sshd_config"
EOT
fi

echo -e "\e[35m[!] DEPLOYMENT COMPLETE! Please reload your terminal or run:\e[0m"
echo -e "\e[35m    source $CONF_FILE\e[0m"
