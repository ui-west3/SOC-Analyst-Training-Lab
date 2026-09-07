#!/usr/bin/env bash
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$LAB_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "[!] Docker is required for SQLi local demo."
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

echo "[+] Starting SQLi local training demo on http://127.0.0.1:8088 ..."
$COMPOSE_CMD up -d --build

echo "[+] Lab is up."
echo "    Open: http://127.0.0.1:8088"
echo "    Monitoring endpoint: http://127.0.0.1:8088/monitoring"
echo "    Logs directory: $LAB_DIR/artifacts"
echo "    Stop lab: ./stop-lab.sh"
