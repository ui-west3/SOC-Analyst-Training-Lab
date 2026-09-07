#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$LAB_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "[!] Docker is required for Hydra 03 FTP lab."
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

echo "[+] Starting FTP target on 127.0.0.1:2121 (host) -> container :21 ..."
$COMPOSE_CMD up -d

echo "[+] Waiting for Pure-FTPd..."
sleep 4

if command -v nc >/dev/null 2>&1; then
  nc -zv 127.0.0.1 2121 2>&1 || true
fi

echo "[+] Lab is up."
echo "    Target: ftp://127.0.0.1:2121 (map 2121 -> 21 in container)"
echo "    Demo creds: labuser / labpass"
echo "    Passive ports on host: 30000-30009 (PUBLICHOST=127.0.0.1)"
echo "    Stop lab: ./stop-lab.sh"
