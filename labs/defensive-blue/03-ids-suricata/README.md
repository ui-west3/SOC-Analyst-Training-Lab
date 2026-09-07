# Blue Lab 03 — Suricata: alert on the Lab 01 pcap

**Status:** planned (needs Lab 01 pcap)  
**Tool:** Suricata  
**Lens:** network IDS on traffic you already captured — not a Wireshark remake  

## 1) Scenario (locked when filming)

Replay or read `labs/defensive-blue/01-wireshark-sqli-pcap/artifacts/sqli-local.pcapng` (or a fresh loopback capture of the same SQLi 00 scene). Enable **one** HTTP-related rule (stock or a lab-local rule). Show the EVE JSON / fast.log alert next to the same URI you already documented in Lab 01.

## 2) Scope & authorization

- Local Suricata, lab pcap, localhost HTTP only.
- Do not point an IDS at networks you do not own.

## 3) Capture (evidence)

```bash
# Placeholder — exact flags after Suricata is installed on the lab box.
# suricata -r path/to/sqli-local.pcapng -l artifacts/
```

## 4) Remediation (Blue)

If the rule is too broad, tighten content/pcre so a normal search does not fire. Document the difference.

## 5) Verification

- Lab 01 pcap still shows the HTTP request.
- Suricata alert timestamp and URI match that request.
- A normal-only pcap does not raise the same alert (or you explain why it does).

## 6) Artifacts

Local `eve.json` / `fast.log` extracts (gitignored when they get large). No production rule dumps.

## 7) Defensive takeaway

- IDS is a second camera on the **same** packets, not a new attack.
- A rule you cannot map back to a pcap is not a closed ticket.

## 8) MITRE ATT&CK mapping

Same technique as Lab 01 once the pcap is real (typically T1190). Confirm from the alert metadata, do not copy-paste in advance.
