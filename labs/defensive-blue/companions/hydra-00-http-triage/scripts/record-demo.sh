#!/usr/bin/env bash
# Silent helper for the Hydra 00 ticket companion (repo demo, not a Blue video).
# Localhost only. Generates failed logins so the analyst panel + triage script have evidence.
set -euo pipefail

LAB="${LAB_URL:-http://127.0.0.1:8765}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ "$LAB" != http://127.0.0.1:* && "$LAB" != http://localhost:* ]]; then
  echo "Refusing non-localhost LAB_URL: $LAB" >&2
  exit 2
fi

pause() {
  echo
  echo "======== $1 ========"
  echo "OBS: F8 pause now if you cut captions by stage. Enter = continue."
  read -r
}

need_lab() {
  if ! curl -sf "$LAB/health" >/dev/null; then
    echo "Lab is not up. In another terminal:" >&2
    echo "  cd labs/offensive-red/hydra/00-speed-vs-detection && ./start-lab.sh" >&2
    echo "  open $LAB" >&2
    exit 1
  fi
}

burst() {
  local n="$1"
  local i
  for i in $(seq 1 "$n"); do
    curl -sS -o /dev/null -w "  %02d  HTTP %{http_code}\n" "$i" \
      -X POST "$LAB/login" \
      --data "username=labuser&password=wrong$i"
  done
}

need_lab

echo "Open $LAB  (right-side log). OBS scene: Browser (F2) or Split (F3)."
echo "F9 start recording before Stage 1."

pause "STAGE 1 — failed login burst (defenses OFF)"
curl -sS -X POST "$LAB/api/settings" \
  -H 'Content-Type: application/json' \
  -d '{"lockout": false, "rate_limit": false}' >/dev/null
burst 12

pause "STAGE 2 — enable lockout, then more attempts"
curl -sS -X POST "$LAB/api/settings" \
  -H 'Content-Type: application/json' \
  -d '{"lockout": true, "rate_limit": true}' >/dev/null
burst 8

pause "STAGE 3 — triage script (verdict + ticket)"
python3 "$ROOT/scripts/triage-http-brute.py" \
  --save "$ROOT/artifacts/events.json" \
  --write-ticket "$ROOT/artifacts/ticket-draft.md"

echo
echo "Done. F10 stop. Caption later:"
echo "  1 burst of failed logins"
echo "  2 lockout fires"
echo "  3 True Positive / T1110"
echo "Ticket: $ROOT/artifacts/ticket-draft.md"
