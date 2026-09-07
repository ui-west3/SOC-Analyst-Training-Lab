#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$LAB_DIR"

mkdir -p input artifacts

cat > input/base-words.txt <<'EOF'
summer
winter
socanalyst
defender
blue
team
EOF

cat > input/demo.rule <<'EOF'
c $1 $9 $9
c $2 $0 $2 $6
EOF

python3 - <<'PY'
import hashlib
from pathlib import Path

passwords = [
    "Summer199",  # crackable with base word + rule "c$1$9$9"
    "blue2026",   # crackable with base word + rule "c$2$0$2$6"
    "test1234",   # crackable by mask ?l?l?l?l?d?d?d?d
]

out = Path("input/hashes-rules-mask.txt")
out.write_text("\n".join(hashlib.sha256(p.encode()).hexdigest() for p in passwords) + "\n", encoding="utf-8")
PY

echo "[+] Generated:"
echo "    input/base-words.txt"
echo "    input/demo.rule"
echo "    input/hashes-rules-mask.txt"
echo "[+] Ready for rule and mask attacks"
