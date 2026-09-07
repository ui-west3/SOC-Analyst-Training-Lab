# Lab 06 — Final automation (master script)

## Goal

Run **one** orchestrated flow that applies Labs **01, 02, 03, 05** in an order that avoids SSH lockout and keeps **SSH port 2222**, **UFW**, and **Fail2Ban** aligned.

**Not included in the script:** Lab 04 (SSH agent forwarding) — that is configured on your **client** (`~/.ssh/config`), not on the server.

## Why this order?

| Step | Lab | Reason |
|:-----|:----|:-------|
| 1 | **02** SSH keys | Backup `sshd_config`, disable passwords only after keys work |
| 2 | **03** Banners + port | Move SSH to **2222** before firewall rules target that port |
| 3 | **01** UFW | Allow **2222/tcp** (rate-limited) + HTTP/HTTPS |
| 4 | **05** Fail2Ban | `jail.local` uses **port = 2222** — must match Lab 03 |

## Prerequisites

- Debian/Ubuntu-style host (`apt`, `systemd`, `ufw`, `ssh`).
- Your **public key** is already in `~/.ssh/authorized_keys` for the user who will log in (test key login **before** running).
- Optional: keep a **second SSH session** open while testing.
- Optional: place `mybanner` or `mybanner.txt` in Lab03 folder or Desktop (see Lab 03 doc); otherwise banner step skips file copy only.

## Run

From the repo:

```bash
cd Linux-Hardening/Lab06-Final-Automation
chmod +x auto-secure.sh
./auto-secure.sh
```

Run as a normal user with `sudo` available (not only as `root`), so Lab 03 can resolve `$SUDO_USER` for aliases.

## Validate

```bash
sudo ufw status verbose
sudo fail2ban-client status sshd
sudo sshd -t && systemctl status ssh --no-pager
```

From another machine: `ssh -p 2222 user@server-ip`


