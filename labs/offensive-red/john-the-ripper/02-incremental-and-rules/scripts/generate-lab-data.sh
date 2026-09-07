#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$LAB_DIR"

mkdir -p input artifacts

cat > input/base-words.txt <<'EOF'
summer
blue
defender
socanalyst
EOF

python3 - <<'PY'
import hashlib
from pathlib import Path

passwords = [
    "Summer1",  # typically reachable via john default wordlist rules
    "1234",     # reachable via incremental digits demo
    "Blue2026", # extra transformed candidate
]

out = Path("input/hashes-john-l02.txt")
out.write_text("\n".join(hashlib.sha256(p.encode()).hexdigest() for p in passwords) + "\n", encoding="utf-8")
PY

echo "[+] Generated:"
echo "    input/base-words.txt"
echo "    input/hashes-john-l02.txt"
echo "[+] Ready for john --rules and --incremental"
