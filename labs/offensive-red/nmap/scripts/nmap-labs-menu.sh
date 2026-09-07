#!/bin/bash
# =============================================================================
# Nmap track — interactive launcher (Labs 01–06)
# =============================================================================
# Calls each lab script in its folder (single source of truth for commands).
#
# Usage:
#   chmod +x nmap-labs-menu.sh
#   ./nmap-labs-menu.sh
#
# Scope: use only on networks and hosts you are authorized to scan.
# =============================================================================

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NMAP_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMMANDS_CHEAT="$NMAP_ROOT/commands.md"

# --- lab scripts (paths mirror repo layout) ---
LAB01="$NMAP_ROOT/01-discovery/nmap-discovery.sh"
LAB02="$NMAP_ROOT/02-syn-scan/nmap-syn-scan.sh"
LAB03="$NMAP_ROOT/03-service-detection/nmap-service-detection.sh"
LAB04="$NMAP_ROOT/04-speed-vs-depth/nmap-speed-vs-depth.sh"
LAB05="$NMAP_ROOT/05-output-reporting/nmap-output-reporting.sh"
LAB06="$NMAP_ROOT/06-safe-nse/nmap-safe-nse.sh"

c_header() { printf '\033[1;36m%s\033[0m\n' "$1"; }
c_dim()    { printf '\033[0;90m%s\033[0m\n' "$1"; }
c_warn()   { printf '\033[1;33m%s\033[0m\n' "$1"; }

require_nmap() {
    if ! command -v nmap &>/dev/null; then
        echo "Error: nmap not installed. Run: sudo apt install nmap"
        return 1
    fi
    return 0
}

ensure_executable() {
    local path="$1"
    if [[ ! -f "$path" ]]; then
        echo "Error: missing script: $path"
        return 1
    fi
    if [[ ! -x "$path" ]]; then
        chmod +x "$path" 2>/dev/null || true
    fi
    return 0
}

run_with_optional_sudo() {
    local script_path="$1"
    local target="$2"
    local suggest_sudo="$3"

    if [[ "$suggest_sudo" == "1" && "$(id -u)" -ne 0 ]]; then
        c_warn "[!] This lab matches the videos best with sudo (raw SYN / discovery)."
        read -r -p "Run with sudo? [y/N] " ans
        if [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]; then
            sudo -E bash "$script_path" "$target"
            return $?
        fi
    fi
    bash "$script_path" "$target"
    return $?
}

show_menu() {
    clear 2>/dev/null || true
    c_header "═══════════════════════════════════════════════════════════════"
    c_header "  Nmap training track — lab launcher"
    c_header "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "  Repo root: $NMAP_ROOT"
    c_dim "  Only scan targets you own or have explicit permission to test."
    echo ""
    echo "  1) Lab 01 — Host discovery     → 01-discovery/nmap-discovery.sh"
    echo "  2) Lab 02 — SYN scan (-sS -Pn) → 02-syn-scan/nmap-syn-scan.sh"
    echo "  3) Lab 03 — Service detection  → 03-service-detection/nmap-service-detection.sh"
    echo "  4) Lab 04 — Speed vs depth     → 04-speed-vs-depth/nmap-speed-vs-depth.sh"
    echo "  5) Lab 05 — Output & reporting → 05-output-reporting/nmap-output-reporting.sh"
    echo "  6) Lab 06 — Safe NSE           → 06-safe-nse/nmap-safe-nse.sh"
    echo ""
    echo "  c) Show path to commands cheat sheet (commands.md)"
    echo "  0) Exit"
    echo ""
}

prompt_target() {
    local example="$1"
    read -r -p "Target (e.g. $example): " t
    echo "$t"
}

action_cheat() {
    echo ""
    if [[ -f "$COMMANDS_CHEAT" ]]; then
        echo "Cheat sheet: $COMMANDS_CHEAT"
        read -r -p "Open with less? [y/N] " ans
        if [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]; then
            less "$COMMANDS_CHEAT"
        fi
    else
        echo "No commands.md found at: $COMMANDS_CHEAT"
    fi
}

main_loop() {
    while true; do
        show_menu
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
            1|2|3|4|5|6)
                ;;
            *)
                c_warn "Unknown option."
                read -r -p "Press Enter to continue..."
                continue
                ;;
        esac

        require_nmap || { read -r -p "Press Enter..." _; continue; }

        local script=""
        local example="10.10.10.5"
        local sudo_hint="0"

        case "$choice" in
            1) script="$LAB01"; example="10.10.10.0/24"; sudo_hint="1" ;;
            2) script="$LAB02"; sudo_hint="1" ;;
            3) script="$LAB03" ;;
            4) script="$LAB04" ;;
            5) script="$LAB05" ;;
            6) script="$LAB06" ;;
        esac

        ensure_executable "$script" || { read -r -p "Press Enter..." _; continue; }

        local target
        target="$(prompt_target "$example")"
        if [[ -z "${target// }" ]]; then
            c_warn "Empty target, cancelled."
            read -r -p "Press Enter to continue..."
            continue
        fi

        echo ""
        run_with_optional_sudo "$script" "$target" "$sudo_hint" || true
        echo ""
        read -r -p "Press Enter to return to menu..."
    done
}

main_loop
