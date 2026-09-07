# SQL Injection Track (Training)

Controlled SQL injection training track for a local lab environment.
Focus: understand attacker thinking and map every step to defender visibility.

## Scope and safety

- Use only isolated local targets.
- Do not test on systems without explicit permission.
- Record both red actions and blue evidence in every exercise.

## Modules

| #   | Module                      | Focus                                      | Status      |
| --- | --------------------------- | ------------------------------------------ | ----------- |
| 00  | Local demo target           | Vulnerable vs safe mode + monitoring board | [▶️ Watch](https://youtu.be/cUcpSuf5EZo) |
| 01  | Simple auth bypass patterns | Input handling weaknesses in login logic   | Planned     |
| 02  | Data extraction concepts    | Error-based, boolean, and blind indicators | Planned     |
| 03  | Advanced simulation         | Time-based behavior and WAF response study | Planned     |
| 04  | Packet / SIEM view          | Same demo traffic on the Blue tool track   | See [Blue Lab 01](../../defensive-blue/01-wireshark-sqli-pcap/) |

## Local demo target

- [`00-local-demo/`](./00-local-demo/) - practical local SQLi learning site with:
  - `vulnerable` and `safe` SQL modes,
  - demo search/login forms,
  - monitoring page for event timeline and SQLi signal detection,
  - admin training dashboard.

## Monitoring-first workflow

1. Start clean logs and baseline traffic.
2. Run one controlled SQLi scenario.
3. Capture artifacts from web, app, and DB layers.
4. Build timeline and map indicators to ATT&CK.
5. Document prevention fix (prepared statements, validation, least privilege).

## SOC takeaway

The goal is not only "how attack works", but also "how fast SOC can detect, explain, and contain it".
