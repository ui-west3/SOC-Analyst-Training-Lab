# Blue Lab 02 — Wazuh: one alert from local logs

**Status:** planned (after Lab 01 video)  
**Tool:** Wazuh (home lab)  
**Lens:** SIEM as the daily SOC surface — not a second packet-capture video  

Splunk query language stays on TryHackMe. This numbered lab is **Wazuh on a machine you own**.

## 1) Scenario (locked when filming)

Ingest one local source (auth, web, or the SQLi demo’s event log). Write **one** decoder/rule or use a stock rule. Show the alert in the Wazuh dashboard with a timestamp that matches the generating event.

## 2) Scope & authorization

- Agents and manager on lab VMs or localhost you own.
- No production tenants, no cloud SIEM you do not administer.

## 3) Capture (evidence)

TBD when the home manager is up: agent install notes, which log file, which rule id, screenshot/export of the alert.

Traffic can come from an existing Red lab (SQLi 00 or Hydra 00). The Blue video does not re-teach that Red tool.

## 4) Remediation (Blue)

Tune the rule so a single benign login does not page you. Document false-positive vs true-positive on the same event class.

## 5) Verification

Alert exists, field mapping is readable, and a rerun of the same lab step reproduces the alert.

## 6) Artifacts

Placeholder until the manager is running. Do not commit API keys or production `ossec.conf`.

## 7) Defensive takeaway

- SOC work is queries and alerts, not only pcaps.
- One well-mapped rule beats a dashboard full of noise.

## 8) MITRE ATT&CK mapping

Fill in from the **actual** log source when the lab is recorded (likely T1110 or T1190, not both).
