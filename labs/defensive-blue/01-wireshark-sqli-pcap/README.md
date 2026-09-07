# Blue Lab 01 — Wireshark: SQLi HTTP evidence

**Status:** docs in repo (video planned)  
**Tool:** Wireshark / tshark  
**Lens:** packet capture on loopback — one scene, one story  
**Red pair:** [SQLi 00 local demo](../../offensive-red/sql-injection/00-local-demo/) (`127.0.0.1:8088`)

Capture the same HTTP the SQLi training site already produces. The Blue video does not re-teach injection. It shows how a SOC analyst isolates the request, follows the stream, and files evidence.

## 1) Scenario

A local product-search form is exercised once with a **normal** query and once with a **suspicious** query (from the demo’s on-screen cheat sheet). You prove, from a pcap, that the HTTP request and response are on disk and readable without guessing from memory.

## 2) Scope & authorization

- **In scope:** loopback traffic to `127.0.0.1:8088` from the SQLi 00 lab you own.
- **Out of scope:** any other host, any capture on a shared network, any third-party site.

## 3) Capture (evidence)

Start the Red target (traffic source only):

```bash
cd labs/offensive-red/sql-injection/00-local-demo
./start-lab.sh
```

Open `http://127.0.0.1:8088/` and `/monitoring`. In Wireshark, capture on the loopback interface (`lo` / `Loopback`). Display filter:

```
tcp.port == 8088
```

In the browser: one normal search, then one suspicious search from the demo cheat sheet, then open `/monitoring`. Stop the capture. Save as `artifacts/sqli-local.pcapng` (local file; not committed).

CLI equivalent (optional):

```bash
# Run as needed for loopback capture on Linux; stop with Ctrl+C after the two searches.
sudo tshark -i lo -f "tcp port 8088" -w artifacts/sqli-local.pcapng
```

See [commands.md](./commands.md) for display filters and follow-stream.

## 4) Remediation (Blue)

This lab does not patch the app (that is SQLi 00 **safe** mode). The Blue action is **evidence hygiene**:

- Keep the pcap next to a short timeline (normal vs suspicious request).
- Note that `/monitoring` is application telemetry; the pcap is network telemetry. Both should agree on time and URI.
- In production: full packet capture is rare; this lab trains the **skill** used when a pcap *is* available (IR, span port, laptop lab).

## 5) Verification

- Pcap opens in Wireshark; filter `http && tcp.port == 8088` shows the two searches.
- Follow HTTP Stream on the suspicious request: method, path, and response status are readable.
- `/monitoring` on the demo shows the same two events in the same order.

## 6) Artifacts

- `commands.md` — capture + display-filter cheat sheet
- `artifacts/` — local `*.pcapng` only (gitignored)

## 7) Defensive takeaway

- A SOC write-up needs **packets or logs**, not a screenshot of the attack tool.
- Loopback HTTP is still HTTP: Host, URI, and body survive in the pcap.
- App monitoring and pcap should tell the same timeline; if they disagree, the ticket is not closed.

## 8) MITRE ATT&CK mapping

| ATT&CK Tactic | Technique ID | Why it matches this lab | Detection idea | Mitigation |
|---|---|---|---|---|
| Initial Access | T1190 | Suspicious input hits a local web app over HTTP | HTTP URI/body anomalies in pcap or WAF/app logs | Parameterized queries, WAF, input validation |
