# Lab 05: Fail2Ban for SSH Brute-Force Defense

This lab adds active SSH brute-force protection with **Fail2Ban** on a hardened Linux host.

## Objective
- Detect repeated failed SSH logins in `/var/log/auth.log`.
- Automatically ban attacker IPs after multiple failed attempts.
- Keep SSH service available on hardened port `2222`.

## Files in this lab
- `jail.local` - local Fail2Ban jail config for `sshd`.
- `install-f2b.sh` - installer/automation script (optional to extend).

## Current `sshd` jail settings
- `enabled = true`
- `port = 2222`
- `maxretry = 5`
- `findtime = 600`
- `bantime = 3600`

This means: if an IP fails SSH auth 5 times within 10 minutes, it is banned for 1 hour.

## Deploy (manual)
1. Install Fail2Ban:
   ```bash
   sudo apt update && sudo apt install -y fail2ban
   ```
2. Copy the jail config:
   ```bash
   sudo cp jail.local /etc/fail2ban/jail.local
   ```
3. Restart and enable service:
   ```bash
   sudo systemctl restart fail2ban
   sudo systemctl enable fail2ban
   ```
4. Verify status:
   ```bash
   sudo fail2ban-client status
   sudo fail2ban-client status sshd
   ```

## SOC validation checklist
- Confirm `sshd` jail is listed as active.
- Generate test failures from another host (wrong password attempts).
- Confirm banned IP appears in `fail2ban-client status sshd`.
- Review logs:
  ```bash
  sudo journalctl -u fail2ban --since "30 min ago"
  sudo tail -f /var/log/auth.log
  ```

## Defensive takeaway
Fail2Ban is a response control, not a primary hardening control. Keep using:
- SSH keys only
- non-default SSH port
- UFW restrictions
- centralized logging where possible

---
Video: [Lab 05 - Fail2Ban](https://youtu.be/KGf3O-4LXkQ?si=MVaqIkHsp7_x4Et6)