#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$LAB_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "[!] Docker is required for Hydra 01 SSH lab."
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD="docker-compose"
else
  echo "[!] Docker Compose is required."
  exit 1
fi

mkdir -p artifacts

echo "[+] Starting SSH target on 127.0.0.1:2222 ..."
$COMPOSE_CMD up -d

echo "[+] Waiting for service to become ready..."
sleep 3

echo "[+] Probe with ssh-keyscan:"
ssh-keyscan -p 2222 127.0.0.1 2>/dev/null | tee artifacts/ssh-keyscan.txt >/dev/null || true

echo "[+] Lab is up."
echo "    Target: 127.0.0.1:2222"
echo "    Demo creds: labuser / labpass"
echo "    Stop lab: ./stop-lab.sh"
