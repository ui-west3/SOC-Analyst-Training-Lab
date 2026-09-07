#!/bin/bash
# =============================================================================
# SOC Linux Hardening — master orchestrator (Labs 01–03, 05)
# =============================================================================
# Safe order (avoids lockout / port mismatch):
#   1. Lab02 — SSH hardening (keys only; backup sshd_config first)
#   2. Lab03 — Port 2222 + banner + aliases (must run as root)
#   3. Lab01 — UFW: allow 2222/tcp with rate limit + HTTP/S
#   4. Lab05 — Fail2Ban (jail expects SSH on 2222)
#
# Lab04 (SSH agent forwarding) is client-side — not automated here.
#
# Usage:
#   chmod +x auto-secure.sh
#   ./auto-secure.sh              # interactive checks
#   sudo ./auto-secure.sh         # same; Lab03 needs root (script will sudo)
#
# Prerequisites:
#   - Debian/Ubuntu with apt, systemd, ufw
#   - Your SSH public key already in ~/.ssh/authorized_keys on THIS host
#   - Second SSH session recommended before disabling passwords
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

LAB02="$LAB_ROOT/Lab02-SSH-Hardening/deploy-keys.sh"
LAB03="$LAB_ROOT/Lab03-SSH-Banners/setup-banners.sh"
LAB01="$LAB_ROOT/Lab01-UFW/setup-ufw.sh"
LAB05_DIR="$LAB_ROOT/Lab05-Fail2Ban"
LAB05="$LAB05_DIR/install-f2b.sh"

RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
NC='\033[0m'

die() { echo -e "${RED}[!] $*${NC}" >&2; exit 1; }
info() { echo -e "${GRN}[*] $*${NC}"; }
warn() { echo -e "${YLW}[!] $*${NC}"; }

for f in "$LAB02" "$LAB03" "$LAB01" "$LAB05"; do
  [[ -f "$f" ]] || die "Missing script: $f"
done
[[ -f "$LAB05_DIR/jail.local" ]] || die "Missing jail.local in $LAB05_DIR"

# --- Pre-flight: avoid lockout when password auth will be disabled ---
REAL_USER="${SUDO_USER:-$USER}"
AUTH_KEYS="$(eval echo "~$REAL_USER")/.ssh/authorized_keys"

if [[ ! -s "$AUTH_KEYS" ]]; then
  warn "No non-empty $AUTH_KEYS — Lab02 disables password login; you may be locked out."
  read -r -p "Abort recommended. Continue anyway? [y/N] " a
  [[ "${a,,}" == "y" ]] || die "Aborted. Add your pubkey to authorized_keys first."
fi

if [[ "$(id -u)" -eq 0 ]]; then
  warn "Running as root: Lab03 expects to be invoked with sudo from a normal user for \$SUDO_USER. Prefer: ./auto-secure.sh as non-root (script uses sudo where needed)."
fi

run_step() {
  local name="$1"
  shift
  info "=== $name ==="
  "$@" || die "Step failed: $name"
}

info "Lab root: $LAB_ROOT"
info "Order: Lab02 → Lab03 → Lab01 → Lab05 (Fail2Ban)"

run_step "Lab02: SSH key-only hardening" bash "$LAB02"

# Lab03 requires EUID 0 (checks EUID -ne 0)
run_step "Lab03: Banners, port 2222, aliases" sudo -E bash "$LAB03"

run_step "Lab01: UFW (SSH 2222 + web)" bash "$LAB01"

run_step "Lab05: Fail2Ban" bash -c "cd \"$LAB05_DIR\" && bash \"$LAB05\""

echo ""
info "=== All automated steps finished ==="
info "Verify: sudo ufw status verbose"
info "Verify: sudo fail2ban-client status sshd"
info "Verify: ssh -p 2222 user@this-host   (from another machine)"
warn "Lab04 (agent forwarding): configure on your *client* (~/.ssh/config); see Lab04 markdown."
echo -e "${GRN}Done.${NC}"
