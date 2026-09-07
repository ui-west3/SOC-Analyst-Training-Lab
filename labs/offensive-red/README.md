# 🔴 Red Team Labs (Offensive)

Hands-on offensive labs for controlled reconnaissance, service analysis, and safe attack-surface simulation.

## 🧭 Quick links

- [Nmap](./nmap/)
- [Hydra](./hydra/)
- [Hashcat](./hashcat/)
- [John the Ripper](./john-the-ripper/)
- [SQL Injection](./sql-injection/)
- [Back to Labs workspace](../README.md)

## 📦 Tool map


| Tool              | Focus area                                                  | Current state                     |
| ----------------- | ----------------------------------------------------------- | --------------------------------- |
| [Nmap](./nmap/)   | Discovery, SYN scan, service detection, reporting, safe NSE | ✅ Published block (01-06)         |
| [Hydra](./hydra/) | Brute-force simulation vs defensive controls                | ✅ Labs 00–03 in repo + `hydra-labs-menu.sh` |
| [Hashcat](./hashcat/) | Offline hash recovery (lab-generated material only)        | ✅ Labs 01–02 published |
| [John the Ripper](./john-the-ripper/) | Offline cracking with John (formats, wordlists)             | 🧱 Lab 01 skeleton — recording queue |
| [SQL Injection](./sql-injection/) | SQLi simulation + SOC monitoring-first response | ✅ Lab 00 published |


## 📌 Folder standard

Each tool folder should contain:

- `README.md` for scope and safety boundaries
- `commands.md` for flags and quick command references
- scripts/artifacts that allow reproducible execution

Purple note: each offensive lab should map to at least one defensive control in the root traceability matrix.