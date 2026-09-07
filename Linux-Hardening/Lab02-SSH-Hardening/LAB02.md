# Lab 02: SSH Security Hardening 🔑

This laboratory focuses on securing the **Secure Shell (SSH)** daemon by transitioning from vulnerable password-based logins to a more robust, key-based authentication model.

### 🎯 Objective
To eliminate the risk of brute-force and credential-stuffing attacks by hardening the SSH configuration and restricting root access.

### 🛠 Security Enhancements in `deploy-keys.sh`:

*   **Automated Backup**: Before making any changes, the script creates a backup of `/etc/ssh/sshd_config`. This ensures a "safe-fail" mechanism.
*   **Password Authentication Disabled**: The script sets `PasswordAuthentication no`. This forces the server to accept only cryptographic SSH keys, rendering traditional password-guessing attacks useless.
*   **Restricted Root Login**: By setting `PermitRootLogin prohibit-password`, the script prevents direct root access via passwords while still allowing secure key-based access if necessary.
*   **Syntax Validation**: Uses `sshd -t` to verify the configuration file before restarting the service. If an error is detected, the script automatically restores the backup to prevent a lockout.
*   **Service Integrity**: Automatically restarts the SSH daemon to apply changes and verifies the service status.

### 🚀 Usage Instruction
**Run this lab first.** Then Lab 03 (banners, port 2222), then Lab 01 (UFW).
1. **Critical:** Ensure your public SSH key is already added to `~/.ssh/authorized_keys` before running this script, or you will lose access!
2. Make the script executable:
   ```bash
   chmod +x deploy-keys.sh
