# 🗺️ SOC Analyst Training Lab — Roadmap

High-level plan for labs, videos, and portfolio evolution.

---

## Progress Snapshot

- Linux Hardening: `<progress value="6" max="6"></progress>` **6/6 (100%)** — docs + scripts; Lab 06 is repo-first (no walkthrough video).
- Nmap Series: `<progress value="6" max="6"></progress>` **6/6 (100%)** — Labs 01–06 published on video.
- Hydra Series: `<progress value="4" max="4"></progress>` **4/4 (100%)** — Labs 00–03 published on video + `hydra-labs-menu.sh`.
- Hashcat Series: `<progress value="2" max="2"></progress>` **2/2 (100%)** — Labs 01–02 published (lab-generated hashes only).
- John the Ripper: `<progress value="0" max="1"></progress>` **0/1 (0%)** — Lab 01 skeleton in repo; recording queue.
- SQL Injection: `<progress value="0" max="1"></progress>` **0/1 videos** — local demo ready in repo.
- Blue Team (`labs/defensive-blue/`): `<progress value="1" max="3"></progress>` **1/3 docs** — Lab 01 Wireshark written; Labs 02–03 planned. **0 videos.** Hydra HTTP triage is a **repo companion**, not Lab 01.
- SOC Analyst Path: Linux + Nmap + Hydra + Hashcat video blocks closed; John + SQLi walkthroughs next; then Blue Wireshark.

---

## ✅ Done — Infrastructure Hardening


| #   | Topic                | Focus                                                             |
| --- | -------------------- | ----------------------------------------------------------------- |
| 01  | Firewall (UFW)       | Default deny, rate limiting                                       |
| 02  | SSH Keys             | Key-based auth                                                    |
| 03  | Security Banners     | MOTD, legal                                                       |
| 04  | SSH Agent Forwarding | Jump servers, bastion                                             |
| 05  | Fail2Ban             | SSH jail, brute-force mitigation                                  |
| 06  | Final Automation     | `auto-secure.sh` — repo/docs only (no separate walkthrough video) |


---

## 🔜 Near term (1–2 months)

- **John the Ripper (Red track)** — Lab 01 walkthrough after Hashcat; [john-the-ripper](./labs/offensive-red/john-the-ripper/); English captions; **lab-generated hashes only**.
- **SQL Injection (Red track)** — walkthrough for the [sql-injection 00 local demo](./labs/offensive-red/sql-injection/00-local-demo/); links synced in root `README.md` and GitHub Pages.
- **Defensive Blue Lab 01** — [Wireshark, one SQLi scene](./labs/defensive-blue/01-wireshark-sqli-pcap/) on loopback (`127.0.0.1:8088`). Same [LAB_TEMPLATE.md](./labs/LAB_TEMPLATE.md). **Do not** remake Hydra 00 as a Blue video.

---

## 📅 Mid term (3–6 months)

- **Blue Lab 02 — Wazuh** — one local log source, one alert ([02-siem-wazuh](./labs/defensive-blue/02-siem-wazuh/)). Splunk SPL stays on TryHackMe.
- **Blue Lab 03 — Suricata** — same pcap as Lab 01, one IDS alert ([03-ids-suricata](./labs/defensive-blue/03-ids-suricata/)).
- **Windows / AD** — baseline hardening and first SOC-focused checks (SOC expansion, not the Blue tool playlist).

---

## 📅 Longer term (6–12 months)

- **Web security bridge** — app exposure mapping and remediation-oriented labs (only if they add a new Purple story).
- **Career package** — interview prep, scenario answers, and concise SOC evidence mapping.

---

## Principles

- One video = one main skill; playlists do not mix tools.
- Blue numbered labs are **defensive tools** (Wireshark, then SIEM, then IDS). Red pentest tools stay on the Red/Purple playlists.
- Each lab maps Red action → Blue mitigation (Purple workflow).
- New labs follow the shared template: `[labs/LAB_TEMPLATE.md](./labs/LAB_TEMPLATE.md)`.
