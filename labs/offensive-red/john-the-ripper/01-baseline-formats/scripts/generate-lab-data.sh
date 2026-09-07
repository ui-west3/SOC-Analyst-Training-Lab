#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$LAB_DIR"

mkdir -p input artifacts

cat > input/wordlist-demo.txt <<'EOF'
123456
password
socanalyst
labpass2026
welcome2026
nottherightone
EOF

python3 - <<'PY'
import hashlib
from pathlib import Path

passwords = [
    "labpass2026",      # crackable from demo wordlist
    "Defensive!2026",   # intentionally absent from demo list
]

out = Path("input/hashes-raw-sha256.txt")
out.write_text("\n".join(hashlib.sha256(p.encode()).hexdigest() for p in passwords) + "\n", encoding="utf-8")
PY

echo "[+] Generated lab input:"
echo "    input/hashes-raw-sha256.txt"
echo "    input/wordlist-demo.txt"
echo "[+] Ready for john --format=Raw-SHA256"
