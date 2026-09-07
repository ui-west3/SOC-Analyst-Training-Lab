# 🔵 Blue Team Labs (Defensive)

Defensive **tool series**, same discipline as Red: **one tool per numbered lab**. The analyst camera is traffic, logs, and detections — not a remake of a Hydra or Nmap video.

Hydra 00 already shows live logs + lockout. That stay on the Red/Purple Hydra playlist. Blue does not film the same HTTP burst again.

**First video lab:** [01-wireshark-sqli-pcap](./01-wireshark-sqli-pcap/) — one SQLi scene on loopback, captured in Wireshark.

## 🧭 Quick links

- [Back to Labs workspace](../README.md)
- [Red Team labs](../offensive-red/)
- [Lab template](../LAB_TEMPLATE.md)
- [Main Purple matrix](../../README.md#-traceability-matrix-attack--defense)
- [Roadmap](../../ROADMAP.md)

## 🧱 Numbered labs (tool track)


| #   | Lab | Tool | Status |
| --- | --- | ---- | ------ |
| 01  | [SQLi HTTP evidence (one scene)](./01-wireshark-sqli-pcap/) | Wireshark / tshark | Docs in repo — first Blue video |
| 02  | [Local log ingest + alert](./02-siem-wazuh/) | Wazuh (home lab) | Planned |
| 03  | [Same pcap, IDS alert](./03-ids-suricata/) | Suricata | Planned — after Lab 01 has a pcap |


Splunk is the query language practiced on TryHackMe. This repo’s SIEM lab is **Wazuh at home**, not Splunk Enterprise.

## 📎 Repo companions (no Blue video)

Ticket-style write-ups that reuse an existing Red lab. They stay in git so a recruiter can see triage, not a second YouTube remake.


| Companion | Pairs with | Status |
| --------- | ---------- | ------ |
| [Hydra 00 HTTP triage](./companions/hydra-00-http-triage/) | [Hydra Lab 00](../offensive-red/hydra/00-speed-vs-detection/) | In repo — ticket + script |


## 📌 Build standard

Each numbered Blue lab includes:

1. Detection goal (one tool, one scene)
2. Data source (PCAP, agent log, IDS alert)
3. How the analyst reads it
4. Validation that the control or detection fired
5. Defensive takeaway + ATT&CK

Purple note: generate traffic from the matching Red lab; do not re-teach that Red tool in the Blue video.

## Naming

- Numbered labs: `NN-tool-short-topic/`
- Companions: `companions/<red-lab>-<topic>/`
- Shared template: [LAB_TEMPLATE.md](../LAB_TEMPLATE.md)
