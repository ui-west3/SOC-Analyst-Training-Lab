# 🛡️ SOC Analyst Training Lab

**MiroslavSec** — practical cybersecurity portfolio for SOC / Blue Team growth with real lab evidence.
**Developed independently by MiroslavSec. Not affiliated with any educational institution.**



[![Status](https://img.shields.io/badge/status-active-22c55e?style=for-the-badge)](https://github.com/ui-west3/SOC-Analyst-Training-Lab)
[![Focus](https://img.shields.io/badge/focus-purple%20team-8b5cf6?style=for-the-badge)](https://github.com/ui-west3/SOC-Analyst-Training-Lab)
[![Content](https://img.shields.io/badge/content-labs%20%2B%20videos-0ea5e9?style=for-the-badge)](https://www.youtube.com/@MiroslavSec1)

[![Last Commit](https://img.shields.io/github/last-commit/ui-west3/SOC-Analyst-Training-Lab?style=for-the-badge)](https://github.com/ui-west3/SOC-Analyst-Training-Lab/commits)
[![Repo Size](https://img.shields.io/github/repo-size/ui-west3/SOC-Analyst-Training-Lab?style=for-the-badge)](https://github.com/ui-west3/SOC-Analyst-Training-Lab)
[![Issues](https://img.shields.io/github/issues/ui-west3/SOC-Analyst-Training-Lab?style=for-the-badge)](https://github.com/ui-west3/SOC-Analyst-Training-Lab/issues)
[![Stars](https://img.shields.io/github/stars/ui-west3/SOC-Analyst-Training-Lab?style=for-the-badge)](https://github.com/ui-west3/SOC-Analyst-Training-Lab/stargazers)

[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-111827?style=for-the-badge&logo=github)](https://github.com/ui-west3/SOC-Analyst-Training-Lab)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0a66c2?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/miroslav-u-7152233b5/)
[![YouTube](https://img.shields.io/badge/YouTube-Watch%20Labs-ff0000?style=for-the-badge&logo=youtube)](https://www.youtube.com/@MiroslavSec1)

> Building public, repeatable SOC skills: attack simulation, defensive validation, and clear documentation.

---

## 🎯 Objective

Build practical evidence of security skills through:

- Linux hardening labs  
- Offensive and defensive tool series  
- TryHackMe daily practice  
- Public documentation and videos

This repository is **portfolio-first**: every block shows **what was done**, **how it was validated**, and **what defensive takeaway was learned**.

---

## 🧭 Quick navigation

- [Tracks overview](#-tracks-overview)
- [Progress dashboard](#-progress-dashboard)
- [Current focus](#-current-focus)
- [Video index](#-video-index)
- [Purple engine](#-purple-engine)
- [Repository structure](#-repository-structure)
- [Quick start](#-quick-start)
- [Portfolio and profiles](#-portfolio--profiles)

---

## 📊 Tracks overview


| Track                     | Scope                                                                                   | Status                       |
| ------------------------- | --------------------------------------------------------------------------------------- | ---------------------------- |
| **Linux Hardening**       | UFW, SSH hardening, banners, agent forwarding, Fail2Ban, final automation               | ✅ **01–06** (docs + scripts) |
| **Red Team (Offensive)**  | Nmap + Hydra + Hashcat on video; **John** queued; SQLi demo (video plan) | 🚧 In progress               |
| **Blue Team (Defensive)** | Tool track: Wireshark → Wazuh → Suricata ([labs/defensive-blue](./labs/defensive-blue/)) | 🧱 Lab 01 docs in repo       |
| **SOC expansion**         | Windows/AD and extra incident cases (not the Blue tool playlist)        | ⏳ Planned                    |


---

## 📈 Progress dashboard


| Series          | Labs total    | Published                              | In repo | Status            |
| --------------- | ------------- | -------------------------------------- | ------- | ----------------- |
| Linux Hardening | 06            | 05 videos + 01 docs/script             | ✅       | 🟢 Stable         |
| Nmap            | 06            | 06 videos                              | ✅       | 🟢 Complete block |
| Hydra           | 00–03         | 04 videos (Labs 00–03) + docs/menu      | ✅       | 🟢 Complete block |
| Hashcat         | 01–02         | 2 videos (Labs 01–02)                    | ✅       | 🟢 Complete block |
| John the Ripper | 01 (planned)  | 0 videos (docs skeleton)                 | ✅       | 🟡 Recording queue |
| SQL Injection   | 00            | 0 videos yet (recording plan ready)    | ✅       | 🟡 Planned videos |
| Defensive Blue  | 01–03         | 0 videos (Lab 01 docs + Hydra ticket companion) | 🧱 | 🔵 Wireshark first |


> Target rhythm: steady weekly releases with one-tool-per-series discipline.

---

## 🚢 What is shipping now

- Nmap core block is published end-to-end (Labs 01-06).
- Hydra **Labs 00–03** have walkthroughs on YouTube; repo includes SSH (Docker + scripts), HTTP form, and FTP targets with compose + `hydra-labs-menu.sh`.
- SQL Injection local demo target is prepared in repo with vulnerable/safe mode, monitoring board, and admin training dashboard (video links to be added after recording).
- **Hashcat** track: Labs 01–02 are published — [Lab 01](https://youtu.be/uwtM6-ZVCSg), [Lab 02](https://youtu.be/CZ6vZzXUn9k) (lab-generated hashes only).
- **John the Ripper** track: [lab docs](./labs/offensive-red/john-the-ripper/) are prepared for the matching offline cracking block.
- **Defensive Blue:** Lab 01 (Wireshark, SQLi loopback pcap) is documented; Labs 02–03 (Wazuh, Suricata) are planned. Hydra HTTP triage is a [repo companion](./labs/defensive-blue/companions/hydra-00-http-triage/), not a Blue episode.
- Shared orchestration scripts are kept in repo for reproducible execution (Nmap menu, Hydra menu).
- Documentation style is unified around scenario -> validation -> takeaway.

---

## 🔥 Current focus

- Daily: TryHackMe learning and notes  
- Weekly: batch recording and scheduled publishing  
- **John the Ripper (Red track):** Lab 01 in recording queue (offline cracking, purple detection notes). Hashcat 01–02 are already published.  
- **SQL Injection (Red track):** local demo is ready; walkthrough links will be added after recording  
- **Defensive Blue:** first video is [Wireshark Lab 01](./labs/defensive-blue/01-wireshark-sqli-pcap/) (one SQLi scene). Then Wazuh, then Suricata. Not a remake of Hydra 00.  
- Rule: **one tool per series** (no mixing tools in one video block)

---

## 📺 Video index

Where a lab has a walkthrough, the link is below. **Shared / orchestration scripts** (Linux Lab 06 `auto-secure.sh`, Nmap `nmap-labs-menu.sh`, Hydra `hydra-labs-menu.sh`) stay **GitHub-only** — documented here, not as a separate video.

### Linux Hardening


| #   | Lab                  | Video / materials                                                  |
| --- | -------------------- | ------------------------------------------------------------------ |
| 01  | Firewall (UFW)       | [▶️ Watch](https://youtu.be/zgGrlMZAEcM)                           |
| 02  | SSH Keys             | [▶️ Watch](https://youtu.be/ULZVP8h6Uvc)                           |
| 03  | Security Banners     | [▶️ Watch](https://youtu.be/ILBxHbIw74Y)                           |
| 04  | SSH Agent Forwarding | [▶️ Watch](https://youtu.be/NOCivaFgoXc)                           |
| 05  | Fail2Ban             | [▶️ Watch](https://youtu.be/KGf3O-4LXkQ?si=MVaqIkHsp7_x4Et6)       |
| 06  | Final Automation     | [Docs + auto-secure.sh](./Linux-Hardening/Lab06-Final-Automation/) |


### Nmap (published)


| #   | Lab                                | Video / materials                                              |
| --- | ---------------------------------- | -------------------------------------------------------------- |
| 01  | Host Discovery + Fast Scan         | [▶️ Watch](https://youtu.be/abxydAApkko)                       |
| 02  | SYN Scan Basics                    | [▶️ Watch](https://youtu.be/vPJW-t86lgc)                       |
| 03  | Service Detection                  | [▶️ Watch](https://youtu.be/vn8LKGCSVQk)                       |
| 04  | Speed vs Depth                     | [▶️ Watch](https://youtu.be/uDrDLcGPx1A)                       |
| 05  | Output & Reporting                 | [▶️ Watch](https://youtu.be/Jk_YhxfHPCw)                       |
| 06  | Safe NSE Intro                     | [▶️ Watch](https://youtu.be/wZI1miGav1w?si=kNtczLp2BnUpQLrL)   |
| —   | Interactive menu (runs Labs 01–06) | [Docs + nmap-labs-menu.sh](./labs/offensive-red/nmap/scripts/) |


### Hydra


| #   | Lab                                                    | Video / materials                                                                           |
| --- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| 00  | Speed vs detection (local range, rate limit / lockout) | [▶️ Watch](https://youtu.be/H16hmZXzrYA)                                                    |
| 01  | SSH brute-force + Fail2Ban bridge (lab + scripts)      | [▶️ Watch](https://youtu.be/-rTCzClzzZQ) · [Docs](./labs/offensive-red/hydra/01-ssh/)       |
| 02  | HTTP form (`http-post-form`, PHP + Apache)             | [▶️ Watch](https://youtu.be/v7YRHpcEzHg) · [Docs](./labs/offensive-red/hydra/02-http-form/) |
| 03  | FTP (Pure-FTPd, PASV on localhost)                     | [▶️ Watch](https://youtu.be/UAhLfay0G-w) · [Docs](./labs/offensive-red/hydra/03-ftp/)        |
| —   | Interactive menu (starts/stops Labs 01–03 targets)     | [Docs + hydra-labs-menu.sh](./labs/offensive-red/hydra/scripts/)                            |

### Hashcat

| #   | Lab | Video / materials |
| --- | --- | ------------------- |
| 01  | Baseline — local lab hashes only | [▶️ Watch](https://youtu.be/uwtM6-ZVCSg) · [Docs](./labs/offensive-red/hashcat/01-baseline-local-hashes/) |
| 02  | Rules + mask attack (candidate expansion) | [▶️ Watch](https://youtu.be/CZ6vZzXUn9k) · [Docs](./labs/offensive-red/hashcat/02-rules-and-mask/) |

### John the Ripper (planned)

| #   | Lab | Video / materials |
| --- | --- | ------------------- |
| 01  | Baseline — formats and wordlist | [Docs (skeleton)](./labs/offensive-red/john-the-ripper/01-baseline-formats/) · 🎬 Planned |

### SQL Injection

| #   | Lab                                                            | Video / materials                                              |
| --- | -------------------------------------------------------------- | -------------------------------------------------------------- |
| 00  | Local training demo (vulnerable vs safe + monitoring + admin) | [Docs (ready)](./labs/offensive-red/sql-injection/00-local-demo/) |
| —   | Follow-up topics (fundamentals, detection/triage angles, etc.) | 🎬 Planned — split into separate videos after Lab 00 walkthrough |

### Defensive Blue

| #   | Lab | Video / materials |
| --- | --- | ------------------- |
| 01  | Wireshark — SQLi HTTP evidence (one scene) | [Docs](./labs/defensive-blue/01-wireshark-sqli-pcap/) · 🎬 Planned |
| 02  | Wazuh — one local alert | [Docs (planned)](./labs/defensive-blue/02-siem-wazuh/) |
| 03  | Suricata — same pcap, one IDS alert | [Docs (planned)](./labs/defensive-blue/03-ids-suricata/) |
| —   | Hydra 00 HTTP ticket (companion, no Blue video) | [Docs](./labs/defensive-blue/companions/hydra-00-http-triage/) |

---

## 🟣 Purple Engine

This portfolio follows a **Purple Team workflow**:

- **Red (offensive):** discover and simulate realistic attack techniques.
- **Blue (defensive):** detect, harden, and validate mitigations.
- **Purple (bridge):** connect attack evidence to concrete defensive actions.

### Traceability Matrix (Attack → Defense)


| Attack phase (Red)       | Tool / technique                   | Detection / mitigation (Blue)                       | Lab evidence                                                                                   |
| ------------------------ | ---------------------------------- | --------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Network recon            | `nmap -sn`, `nmap -sV`             | Service minimization, banner strategy, segmentation | [Nmap Lab 01–03](./labs/offensive-red/nmap/)                                                   |
| Port exposure mapping    | SYN scan (`-sS -Pn`)               | Firewall rule review + exposure baseline            | [Nmap Lab 02](./labs/offensive-red/nmap/02-syn-scan/)                                          |
| Brute-force simulation   | Hydra (web lab + SSH / HTTP / FTP) | Fail2Ban, WAF/rate limits, SFTP vs FTP, keys/MFA    | [Hydra 00–03](./labs/offensive-red/hydra/) · [Linux Lab 05](./Linux-Hardening/Lab05-Fail2Ban/) |
| Offline hash cracking    | Hashcat / John (lab-generated hashes) | Strong KDFs, protect backups & DC sync, MFA for online paths, monitor credential theft | [Hashcat track](./labs/offensive-red/hashcat/) · [John track](./labs/offensive-red/john-the-ripper/) |
| SQL injection simulation | SQLi local demo (`vulnerable` / `safe`) | Parameterized queries, input validation, query-event monitoring, **pcap evidence** | [SQLi 00](./labs/offensive-red/sql-injection/00-local-demo/) · [Blue Lab 01 Wireshark](./labs/defensive-blue/01-wireshark-sqli-pcap/) |
| Safe service enumeration | NSE `--script safe`                | Logging + anomalous pattern monitoring              | [Nmap Lab 06](./labs/offensive-red/nmap/06-safe-nse/)                                          |
| SSH hardening validation | Key-only auth / custom port checks | `sshd_config` policy + UFW + backup-and-verify flow | [Linux Lab 02/03/06](./Linux-Hardening/)                                                       |


### Lab Standard

Every lab should follow the same engineering format:

1. **Scenario** — what problem is being solved?
2. **Scope & authorization** — lab-only and authorized targets.
3. **Reproduction (Red)** — how the issue is observed.
4. **Remediation (Blue)** — fix/hardening steps.
5. **Verification** — proof that behavior changed after fixes.
6. **Artifacts** — scripts, command logs, or reports.
7. **Defensive takeaway** — SOC-relevant conclusion.
8. **MITRE ATT&CK mapping** — 1-3 techniques with detection + mitigation notes.

Template: `[labs/LAB_TEMPLATE.md](./labs/LAB_TEMPLATE.md)`

---

## 📁 Repository structure


| Path                                                                       | Purpose                                                   |
| -------------------------------------------------------------------------- | --------------------------------------------------------- |
| `[Linux-Hardening/](./Linux-Hardening/)`                                   | Linux series (labs 01–06)                                 |
| `[labs/offensive-red/](./labs/offensive-red/)`                             | Red Team tools and workflows (Nmap/Hydra/...)             |
| `[labs/offensive-red/hydra/scripts/](./labs/offensive-red/hydra/scripts/)` | Hydra `hydra-labs-menu.sh` (start/stop Docker labs 01–03) |
| `[labs/offensive-red/hashcat/](./labs/offensive-red/hashcat/)` | Offline hash cracking (Hashcat) — lab-only material |
| `[labs/offensive-red/john-the-ripper/](./labs/offensive-red/john-the-ripper/)` | Offline hash cracking (John the Ripper) — lab-only material |
| `[labs/offensive-red/sql-injection/00-local-demo/](./labs/offensive-red/sql-injection/00-local-demo/)` | SQLi local training target (Docker, monitoring, admin demo) |
| `[labs/defensive-blue/](./labs/defensive-blue/)`                           | Blue tool track (Wireshark → Wazuh → Suricata) + ticket companions |
| `[labs/LAB_TEMPLATE.md](./labs/LAB_TEMPLATE.md)`                           | Standard template for consistent lab quality              |
| `[docs/](./docs/)`                                                         | Portfolio site (GitHub Pages)                             |
| `[scripts/](./scripts/)`                                                   | Shared automation helpers                                 |
| `[ROADMAP.md](./ROADMAP.md)`                                               | High-level timeline and next steps                        |
| `[LICENSE](./LICENSE)`                                                     | MIT — code and docs in this repo                          |


---

## ✅ Content standards

- One video = one main skill.  
- One series = one tool (no tool mixing).  
- Lab docs use named markdown files (`LABxx.md` or `Labxx-*.md`).  
- Each lab includes: objective → steps → validation → **defensive takeaway** (purple angle where it fits).

---

## 🚀 Release workflow

1. Publish or schedule the lab video.
2. Sync documentation and public links in repository and website.
3. Keep titles and naming consistent across GitHub, website, and playlist.

---

## ⚙️ Quick start

```bash
git clone https://github.com/ui-west3/SOC-Analyst-Training-Lab.git
cd SOC-Analyst-Training-Lab
```

Open the lab folder you need and follow its markdown guide.

### Linux Hardening — master script (final runbook)

After you understand each step, you can chain **labs 02 + 03 + 01 + 05** in one safe order (SSH **2222**, UFW, Fail2Ban stay aligned):

```bash
cd Linux-Hardening/Lab06-Final-Automation
chmod +x auto-secure.sh
./auto-secure.sh
```

- **Write-up:** `[Lab06-Final-Automation.md](./Linux-Hardening/Lab06-Final-Automation/Lab06-Final-Automation.md)`  
- **Order:** Lab 02 (keys) → Lab 03 (port/banner) → Lab 01 (UFW) → Lab 05 (Fail2Ban). Lab 04 is **client-side** only.  
- **Before:** your public key in `~/.ssh/authorized_keys` and a tested SSH login; keep a spare session open.

---

## 🌐 Portfolio & profiles

- **Website:** [MiroslavSec](https://ui-west3.github.io/SOC-Analyst-Training-Lab/)  
- **Certification museum:** [Certifications](https://ui-west3.github.io/SOC-Analyst-Training-Lab/certifications.html)  
- **TryHackMe:** [MiroslavSEC](https://tryhackme.com/p/MiroslavSEC)  
- **YouTube:** [MiroslavSec1](https://www.youtube.com/@MiroslavSec1)  
- **LinkedIn:** [miroslav-u-7152233b5](https://www.linkedin.com/in/miroslav-u-7152233b5/)

---

## 🤝 Collaboration

If you are building your own SOC path, feel free to open an issue or drop feedback on lab structure, detection notes, or workflow ideas.