# Nmap

Focused Nmap learning track with short labs and clear blue-team takeaways.

## 🧭 Quick links

- [Back to Red Team labs](../README.md)
- [Shared scripts](./scripts/)
- [Main video index](../../../README.md#-video-index)

## Track Rules

- One lab = one Nmap concept.
- No tool mixing inside this track.
- Every lab includes a defensive note (purple mindset).

## Sections


| #   | Section                                        | Description                                                      | Status |
| --- | ---------------------------------------------- | ---------------------------------------------------------------- | ------ |
| 01  | [Discovery](./01-discovery/)                   | Host discovery — TCP SYN ping vs ICMP; `live-hosts.txt` workflow | ✅      |
| 02  | [SYN Scan](./02-syn-scan/)                     | `-sS -Pn` baseline scan                                          | ✅      |
| 03  | [Service Detection](./03-service-detection/)   | `-sV` and exposure review                                        | ✅      |
| 04  | [Speed vs Depth](./04-speed-vs-depth/)         | targeted ports vs full range                                     | ✅      |
| 05  | [Output and Reporting](./05-output-reporting/) | `-oN`, `-oA`, baseline snapshots                                 | ✅      |
| 06  | [Safe NSE Intro](./06-safe-nse/)               | `--script safe` basics                                           | ✅      |


**Walkthrough (Lab 06):** [▶️ Watch on YouTube](https://youtu.be/wZI1miGav1w?si=kNtczLp2BnUpQLrL) — full Nmap track index is in the [repository root `README.md`](../../../README.md#-video-index).

## 📊 Track status


| Metric              | Value                   |
| ------------------- | ----------------------- |
| Total labs in block | 6                       |
| Published videos    | 6                       |
| Shared launcher     | `nmap-labs-menu.sh`     |
| Current state       | Stable and reproducible |


## Shared Files

- [commands.md](./commands.md) - quick flags cheat sheet.
- [scripts/](./scripts/) - reusable Nmap scripts:
  - `nmap-labs-menu.sh` — interactive menu that runs Labs **01–06** (calls each lab script in its folder; good entry point for beginners).
  - `nmap-scan.sh` (recon workflow)
  - `nmap-defend-check.sh` (defensive checks)

### Quick start (menu)

```bash
cd labs/offensive-red/nmap/scripts
chmod +x nmap-labs-menu.sh
./nmap-labs-menu.sh
```

For learning, still read each lab’s `README.md` first; the menu is a convenience launcher, not a replacement for one-concept-per-lab practice.