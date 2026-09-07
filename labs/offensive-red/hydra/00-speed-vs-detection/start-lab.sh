#!/bin/bash
# Start the Lab 00 training web UI (127.0.0.1 only).
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v python3 &>/dev/null; then
  echo "python3 not found."
  exit 1
fi

if [[ ! -d .venv ]]; then
  python3 -m venv .venv
fi
# shellcheck source=/dev/null
source .venv/bin/activate
pip install -q -r requirements.txt

export LAB_HOST="${LAB_HOST:-127.0.0.1}"
export LAB_PORT="${LAB_PORT:-8765}"
exec python app.py
