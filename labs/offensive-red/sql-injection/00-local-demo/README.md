# SQL Injection 00 - Local Demo Target

Local-only SQL injection training website for practical demos and SOC-style monitoring.

## Goal

Provide a clean, record-ready target where you can compare:

- vulnerable SQL query handling,
- safe parameterized mode,
- monitoring and event correlation.

## Safety

- Bind only to `127.0.0.1:8088`.
- Use this lab only on your own local environment.
- Educational purpose only.

## Components

- Flask app with two actions:
  - product search (`search`),
  - demo login (`login`).
- Two modes:
  - `vulnerable` (string-built SQL),
  - `safe` (parameterized query).
- Monitoring page:
  - latest events,
  - SQLi signal counters,
  - vulnerable vs safe activity counts,
  - manual "Clear Monitoring Board" action.
- Seeded training data:
  - 60 extra users (`user01..user60`),
  - 80 product rows,
  - 40 incident rows for admin dashboard practice.

## Quick start

```bash
cd labs/offensive-red/sql-injection/00-local-demo
chmod +x start-lab.sh stop-lab.sh
./start-lab.sh
```

Open:

- Demo UI: `http://127.0.0.1:8088`
- Monitoring: `http://127.0.0.1:8088/monitoring`
- Admin dashboard: `http://127.0.0.1:8088/admin` (login as `admin`)

Stop:

```bash
./stop-lab.sh
```

## Recording flow (recommended)

1. Run a normal input in both modes.
2. Run suspicious input in vulnerable mode.
3. Repeat same input in safe mode.
4. Open `/monitoring` and explain:
   - event timeline,
   - signal matches,
   - defender takeaway.

Packet-capture angle (Wireshark, one scene, same localhost app): [Blue Lab 01](../../../defensive-blue/01-wireshark-sqli-pcap/). Do not mix Hydra into that video.

## Built-in cheat sheet

The main page now includes a "SQLi Cheat Sheet (Training)" section with:

- injection type and its purpose,
- where to test it in this lab (`search` or `login`),
- expected difference between `vulnerable` and `safe`,
- defender/SOC takeaway for triage and mitigation.

Use this section as an on-screen prompt during demos or class practice.

## Artifacts

- `artifacts/training.db` — SQLite lab database (created at runtime; **not committed** to Git).
- `artifacts/events.log` — newline-delimited JSON event stream for the monitoring page (runtime; **not committed**).

Repository root `.gitignore` excludes `*.db` / `*.log` under this `artifacts/` path so local practice does not pollute commits.

## Notes

- If an old DB seed is already present, remove `artifacts/training.db` and restart the container to regenerate the full seeded dataset.
