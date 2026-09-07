#!/usr/bin/env bash
# =============================================================================
# Hydra track — interactive launcher (Labs 01–03 Docker targets)
# =============================================================================
# Starts/stops each lab via its folder scripts (single source of truth).
#
# Usage:
#   chmod +x hydra-labs-menu.sh
#   ./hydra-labs-menu.sh
#
# Scope: localhost training targets only; do not use against third parties.
# =============================================================================

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HYDRA_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMMANDS_CHEAT="$HYDRA_ROOT/commands.md"

LAB01="$HYDRA_ROOT/01-ssh"
LAB02="$HYDRA_ROOT/02-http-form"
LAB03="$HYDRA_ROOT/03-ftp"

c_header() { printf '\033[1;36m%s\033[0m\n' "$1"; }
c_dim()    { printf '\033[0;90m%s\033[0m\n' "$1"; }
c_warn()   { printf '\033[1;33m%s\033[0m\n' "$1"; }

require_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "Error: docker not installed or not in PATH."
        return 1
    fi
    return 0
}

ensure_lab_scripts() {
    local dir="$1"
    local start_s="$dir/start-lab.sh"
    local stop_s="$dir/stop-lab.sh"
    if [[ ! -f "$start_s" || ! -f "$stop_s" ]]; then
        echo "Error: missing start/stop in $dir"
        return 1
    fi
    chmod +x "$start_s" "$stop_s" 2>/dev/null || true
    return 0
}

run_start() {
    local dir="$1"
    ensure_lab_scripts "$dir" || return 1
    require_docker || return 1
    bash "$dir/start-lab.sh"
}

run_stop() {
    local dir="$1"
    ensure_lab_scripts "$dir" || return 1
    require_docker || return 1
    bash "$dir/stop-lab.sh"
}

action_cheat() {
    echo ""
    if [[ -f "$COMMANDS_CHEAT" ]]; then
        echo "Track cheat / index: $COMMANDS_CHEAT"
        read -r -p "Open with less? [y/N] " ans
        if [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]; then
            less "$COMMANDS_CHEAT"
        fi
    else
        echo "No commands.md found at: $COMMANDS_CHEAT"
    fi
}

lab_submenu() {
    local num="$1"
    local title="$2"
    local dir="$3"

    while true; do
        clear 2>/dev/null || true
        c_header "═══════════════════════════════════════════════════════════════"
        c_header "  Hydra Lab $num — $title"
        c_header "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "  Folder: $dir"
        c_dim "  README.md and commands.md are the source of truth for Hydra syntax."
        echo ""
        echo "  1) Start target (./start-lab.sh)"
        echo "  2) Stop target  (./stop-lab.sh)"
        echo "  r) Print paths to README + commands.md"
        echo "  b) Back to main menu"
        echo ""
        read -r -p "Choose: " sub
        sub="${sub,,}"

        case "$sub" in
            b|0)
                return 0
                ;;
            r)
                echo ""
                echo "  README:    $dir/README.md"
                echo "  Commands:  $dir/commands.md"
                read -r -p "Press Enter..."
                continue
                ;;
            1)
                echo ""
                run_start "$dir" || true
                echo ""
                read -r -p "Press Enter..."
                ;;
            2)
                echo ""
                run_stop "$dir" || true
                echo ""
                read -r -p "Press Enter..."
                ;;
            *)
                c_warn "Unknown option."
                read -r -p "Press Enter..."
                ;;
        esac
    done
}

show_main_menu() {
    clear 2>/dev/null || true
    c_header "═══════════════════════════════════════════════════════════════"
    c_header "  Hydra training track — Docker lab launcher"
    c_header "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "  Repo root: $HYDRA_ROOT"
    c_dim "  Localhost targets only. Lab 00 (Flask) is started separately — see 00-speed-vs-detection/README.md"
    echo ""
    echo "  1) Lab 01 — SSH brute-force        → 01-ssh/"
    echo "  2) Lab 02 — HTTP form (post-form)  → 02-http-form/"
    echo "  3) Lab 03 — FTP brute-force        → 03-ftp/"
    echo ""
    echo "  c) Track cheat sheet (commands.md index + per-lab links)"
    echo "  0) Exit"
    echo ""
}

main_loop() {
    while true; do
        show_main_menu
        read -r -p "Choose option: " choice
        choice="${choice,,}"

        case "$choice" in
            0)
                echo "Bye."
                exit 0
                ;;
            c)
                action_cheat
                read -r -p "Press Enter to continue..."
                continue
                ;;
            1)
                lab_submenu "01" "SSH" "$LAB01"
                ;;
            2)
                lab_submenu "02" "HTTP form" "$LAB02"
                ;;
            3)
                lab_submenu "03" "FTP" "$LAB03"
                ;;
            *)
                c_warn "Unknown option."
                read -r -p "Press Enter to continue..."
                ;;
        esac
    done
}

main_loop
