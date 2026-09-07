# Hydra

Brute-force simulation: **SSH**, **HTTP form**, **FTP**, and more — each lab is a **localhost Docker target** plus a **purple** defensive bridge.

Lab 00 (Flask web app) is the intro to **speed vs detection** on a custom training range — see [00-speed-vs-detection](./00-speed-vs-detection/). **Miroslav Ustimenko**, SOC Analyst Training Lab — **2026** (local-only; see each folder README).

## 🧭 Quick links

- [Back to Red Team labs](../README.md)
- [Track-level command index](./commands.md)
- [Shared launcher](./scripts/)
- [Main video index](../../../README.md#-video-index)

## Track rules

- One lab = one **Hydra module / service** shape (SSH vs `http-post-form` vs FTP).
- Targets stay on **127.0.0.1** with published ports documented per lab.
- Every lab ends with **Blue** detection and **mitigation** notes.

## Sections


| #   | Folder                                         | Description                                                              | Video / status                           |
| --- | ---------------------------------------------- | ------------------------------------------------------------------------ | ---------------------------------------- |
| 00  | [speed-vs-detection](./00-speed-vs-detection/) | Local Flask app: login + live log + defense toggles (speed vs detection) | [▶️ Watch](https://youtu.be/H16hmZXzrYA) |
| 01  | [01-ssh](./01-ssh/)                            | SSH brute-force vs Docker OpenSSH; Fail2Ban bridge                       | [▶️ Watch](https://youtu.be/-rTCzClzzZQ) |
| 02  | [02-http-form](./02-http-form/)                | `http-post-form` vs PHP login (Apache)                                   | [▶️ Watch](https://youtu.be/v7YRHpcEzHg) |
| 03  | [03-ftp](./03-ftp/)                            | FTP brute-force vs Pure-FTPd (PASV on localhost)                         | [▶️ Watch](https://youtu.be/UAhLfay0G-w) |


Ticket close-out for Lab 00 (script + sample events, **not** a Blue video): [hydra-00-http-triage](../../defensive-blue/companions/hydra-00-http-triage/).


## 📊 Track status


| Metric              | Value                                      |
| ------------------- | ------------------------------------------ |
| Published videos    | 4 (Labs 00–03)                             |
| Docker service labs | 3 (01 SSH, 02 HTTP form, 03 FTP)           |
| Shared launcher     | `scripts/hydra-labs-menu.sh`               |
| Command index       | `[commands.md](./commands.md)`             |
| Current state       | Reproducible compose + scripts + artifacts |


## Shared files

- `[commands.md](./commands.md)` — track-level index linking to each lab’s `commands.md`.
- `[scripts/](./scripts/)` — `hydra-labs-menu.sh`: interactive **start/stop** for Labs **01–03** (calls each folder’s `start-lab.sh` / `stop-lab.sh`).

### Quick start (menu)

```bash
cd labs/offensive-red/hydra/scripts
chmod +x hydra-labs-menu.sh
./hydra-labs-menu.sh
```

Read each lab’s `README.md` before recording; the menu is a convenience launcher, not a substitute for understanding **scope**, **failure strings** (HTTP), and **PASV** (FTP).