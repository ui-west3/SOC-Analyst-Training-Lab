# Companion — Hydra 00 HTTP triage (analyst commands)

Lab-only. Default target is `127.0.0.1:8765`.

# Optional silent demo (repo companion — not the Blue YouTube episode)

Three on-screen stages if you want a local recording of the ticket flow. Hydra is not required. The published Blue series starts at Wireshark Lab 01.

1. Terminal A: `cd labs/offensive-red/hydra/00-speed-vs-detection && ./start-lab.sh` → open `http://127.0.0.1:8765/`
2. OBS: Browser (F2) or Split (F3). **F9** record.
3. Terminal B:

```bash
cd labs/defensive-blue/companions/hydra-00-http-triage
chmod +x scripts/record-demo.sh
./scripts/record-demo.sh
```

Enter between stages (optional **F8** pause for cleaner cuts). **F10** stop. Remux mkv → mp4.

Caption list: (1) failed-login burst (2) lockout fires (3) script verdict True Positive / T1110.

## Pull live events

```bash
curl -sS http://127.0.0.1:8765/api/logs | python3 -m json.tool
```

Count failure details:

```bash
curl -sS http://127.0.0.1:8765/api/logs \
  | python3 -c 'import json,sys; from collections import Counter; e=json.load(sys.stdin)["events"]; print(Counter(x.get("detail") for x in e))'
```

## Triage script

```bash
cd labs/defensive-blue/companions/hydra-00-http-triage
python3 scripts/triage-http-brute.py
python3 scripts/triage-http-brute.py --from artifacts/events-sample.json
python3 scripts/triage-http-brute.py --save artifacts/events.json --write-ticket artifacts/ticket-draft.md
```

## Enable lockout on the lab (optional)

```bash
curl -sS -X POST http://127.0.0.1:8765/api/settings \
  -H 'Content-Type: application/json' \
  -d '{"lockout": true, "rate_limit": true}'
```
