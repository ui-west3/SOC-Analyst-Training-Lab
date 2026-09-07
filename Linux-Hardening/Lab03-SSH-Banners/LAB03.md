# Lab #3: Professional SSH Hardening & Zsh Aliases 🛡️

In this laboratory work, we implement essential security measures for an SSH server and optimize the environment for a SOC Analyst.

## 📋 What's inside?
- **Port Obfuscation:** Shifting SSH from port 22 to **2222** to avoid automated bot scans.
- **Legal Defense:** Implementing a custom legal warning banner via `/etc/issue.net`.
- **Productivity Kit:** Custom Zsh/Bash aliases for real-time monitoring.

## 🚀 How to Deploy
**Recommended:** Run Lab 02 (SSH Keys) first to avoid lockout. Run Lab 01 (UFW) after this lab — UFW allows port 2222, which Lab 03 configures.
1. **Prepare your banner:** Use the provided `mybanner` file in this directory.
2. **Run the automation script:**
   ```bash
   chmod +x setup-banners.sh
   sudo ./setup-banners.sh
