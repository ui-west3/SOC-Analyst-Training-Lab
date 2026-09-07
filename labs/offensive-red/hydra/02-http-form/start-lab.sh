#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$LAB_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "[!] Docker is required for Hydra 02 HTTP form lab."
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

echo "[+] Starting HTTP form target on http://127.0.0.1:8080/ ..."
$COMPOSE_CMD up -d

echo "[+] Waiting for Apache + PHP..."
sleep 3

if command -v curl >/dev/null 2>&1; then
  curl -sS -o /dev/null -w "HTTP %{http_code} on /login.php\n" "http://127.0.0.1:8080/login.php" || true
fi

echo "[+] Lab is up."
echo "    Login URL: http://127.0.0.1:8080/login.php"
echo "    Demo creds: labuser / labpass"
echo "    Stop lab: ./stop-lab.sh"
