# SOC Analyst Training Lab

**MiroslavSec** — hands-on purple-team portfolio: attack the lab, prove the signal, write the takeaway.

Independent work. Not affiliated with any school or employer.

[Website](https://ui-west3.github.io/SOC-Analyst-Training-Lab/) · [Certification Museum](https://ui-west3.github.io/SOC-Analyst-Training-Lab/certifications.html) · [YouTube](https://www.youtube.com/@MiroslavSec1) · [TryHackMe](https://tryhackme.com/p/MiroslavSEC) · [LinkedIn](https://www.linkedin.com/in/miroslav-u-7152233b5/)

---

## Tracks

| Track | Status | Where |
| --- | --- | --- |
| Linux Hardening | Done (01–06) | [`Linux-Hardening/`](./Linux-Hardening/) |
| Nmap | Done (01–06) | [`labs/offensive-red/nmap/`](./labs/offensive-red/nmap/) |
| Hydra | Done (00–03) | [`labs/offensive-red/hydra/`](./labs/offensive-red/hydra/) |
| Hashcat | Done (01–02) | [`labs/offensive-red/hashcat/`](./labs/offensive-red/hashcat/) |
| SQL Injection | Lab 00 live | [`labs/offensive-red/sql-injection/`](./labs/offensive-red/sql-injection/) |
| John the Ripper | Docs ready | [`labs/offensive-red/john-the-ripper/`](./labs/offensive-red/john-the-ripper/) |
| Defensive Blue | Wireshark docs → Wazuh → Suricata | [`labs/defensive-blue/`](./labs/defensive-blue/) |

Full video index: [`docs/VIDEOS.md`](./docs/VIDEOS.md) · Plan: [`ROADMAP.md`](./ROADMAP.md)

---

## Now

- **Blue Lab 01** — Wireshark on the SQLi loopback scene  
- **Centri** — BTJA in progress (OSINT intro already in the museum)  
- **Red** — John Lab 01 when recording energy is back  

Rule: one tool per series. Blue does not remake Hydra/Nmap videos.

---

## Purple idea

| Red | Blue bridge |
| --- | --- |
| Recon / Nmap | Exposure + hardening |
| Brute force / Hydra | Fail2Ban, rate limits, triage ticket |
| SQLi local demo | App monitoring + Wireshark pcap evidence |
| Hashcat / John (lab hashes only) | Credential hygiene notes |

Lab format: [`labs/LAB_TEMPLATE.md`](./labs/LAB_TEMPLATE.md)

---

## Quick start

```bash
git clone https://github.com/ui-west3/SOC-Analyst-Training-Lab.git
cd SOC-Analyst-Training-Lab
```

Open any lab folder and follow its markdown.

Linux master script (after you understand labs 01–05):

```bash
cd Linux-Hardening/Lab06-Final-Automation
chmod +x auto-secure.sh
./auto-secure.sh
```

SQLi training target:

```bash
cd labs/offensive-red/sql-injection/00-local-demo
./start-lab.sh   # Docker — or run app via local venv if compose DNS fails
```

---

## Layout

```
Linux-Hardening/          # UFW → SSH → Fail2Ban → automation
labs/offensive-red/       # Nmap, Hydra, Hashcat, John, SQLi
labs/defensive-blue/      # Wireshark, Wazuh, Suricata + companions
docs/                     # GitHub Pages site + Certification Museum
scripts/                  # shared helpers
```

---

## Notes

- Labs are for **authorized / local** targets only.  
- Hash cracking materials use **lab-generated** hashes.  
- MIT license — see [`LICENSE`](./LICENSE).
