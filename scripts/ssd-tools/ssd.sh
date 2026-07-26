#!/bin/zsh
# SSD Tools Menu

SCRIPTS_DIR="{{SSD_MOUNT}}/Dev/scripts/ssd-tools"

MENU=(
  "1:mount-check:Check SSD mount + symlink health:1-mount-check.sh"
  "2:cache-cleanup:Clear caches (Library, npm, pnpm):2-cache-cleanup.sh"
  "3:low-disk-alert:Check internal Mac free space:3-low-disk-alert.sh"
  "4:node-modules-cleaner:Find/delete stale node_modules:4-node-modules-cleaner.sh"
  "5:dev-backup:Rsync active projects to SSD backup:5-dev-backup.sh"
  "6:serial-lock:Check this Mac is authorised:6-serial-lock.sh"
  "7:duplicate-finder:Scan SSD for duplicate files:7-duplicate-finder.sh"
  "8:large-file-tracker:Weekly large file report:8-large-file-tracker.sh"
  "9:git-status:Uncommitted changes across all projects:9-git-status-report.sh"
  "10:stale-branches:Delete merged git branches:10-stale-branch-cleaner.sh"
  "11:dep-audit:npm vulnerability scan:11-dependency-audit.sh"
  "12:ssd-health:SSD space + fill prediction:12-ssd-health.sh"
  "13:startup-optimizer:Kill memory hogs:13-startup-optimizer.sh"
  "14:screenshot-organizer:Move screenshots off Desktop:14-screenshot-organizer.sh"
  "15:project-switcher:Open project in VS Code:15-project-switcher.sh"
  "16:daily-dev-log:Create today's dev log files:16-daily-dev-log.sh"
  "17:app-usage:Show today's app usage report:17-app-usage-tracker.sh --report"
  "18:ram-monitor:Check RAM + kill heaviest process:18-ram-monitor.sh"
  "19:battery-logger:Log battery health + cycles:19-battery-logger.sh"
  "20:env-backup:Backup all .env files:20-env-backup.sh"
  "21:port-resolver:Scan ports 3000-3010:21-port-resolver.sh"
  "22:dep-updater:npm update + commit all projects:22-dep-updater.sh"
  "23:auto-eject:Eject/mount/status SSD:23-auto-eject.sh"
  "24:folder-dashboard:Live SSD size dashboard:24-folder-dashboard.sh"
  "25:focus-mode:Start focus session (25min default):25-focus-mode.sh"
  "26:meeting-prep:Prep workspace for meeting:26-meeting-prep.sh"
)

print_menu() {
  clear

  # Colors
  local RESET='\033[0m'
  local BOLD='\033[1m'
  local DIM='\033[2m'
  local CYAN='\033[36m'
  local YELLOW='\033[33m'
  local GREEN='\033[32m'
  local RED='\033[31m'
  local WHITE='\033[97m'
  local BG_DARK='\033[40m'

  # Header
  echo -e "${CYAN}${BOLD}"
  echo "  ╔═══════════════════════════════════════════════════════════════════════╗"
  echo "  ║                                                                       ║"
  echo "  ║                      ◈  SSD TOOLS — 007  ◈                           ║"
  echo "  ║                                                                       ║"
  echo "  ╚═══════════════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"

  # Status bar
  if [ -d "{{SSD_MOUNT}}" ]; then
    FREE=$(df -h {{SSD_MOUNT}} | tail -1 | awk '{print $4}')
    USED=$(df -h {{SSD_MOUNT}} | tail -1 | awk '{print $3}')
    MAC_FREE=$(df -h / | tail -1 | awk '{print $4}')
    MAC_USED=$(df -h / | tail -1 | awk '{print $3}')
    echo -e "  ${DIM}┌─────────────────────────────────────────────────────────────────────┐${RESET}"
    printf "  ${DIM}│${RESET}  ${GREEN}●${RESET} SSD 007   ${BOLD}${FREE} free${RESET} / ${DIM}${USED} used${RESET}          ${CYAN}●${RESET} Mac Internal  ${BOLD}${MAC_FREE} free${RESET} / ${DIM}${MAC_USED} used${RESET}  ${DIM}│${RESET}\n"
    echo -e "  ${DIM}└─────────────────────────────────────────────────────────────────────┘${RESET}"
  else
    echo -e "  ${DIM}┌─────────────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "  ${DIM}│${RESET}  ${RED}✖ SSD NOT MOUNTED — plug in your drive${RESET}                               ${DIM}│${RESET}"
    echo -e "  ${DIM}└─────────────────────────────────────────────────────────────────────┘${RESET}"
  fi

  echo ""

  # Section: Storage
  echo -e "  ${YELLOW}${BOLD}  STORAGE & SYSTEM${RESET}"
  echo -e "  ${DIM}┌──────┬──────────────────────┬────────────────────────────────────────┐${RESET}"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "1"  "mount-check"        "Check SSD mount + symlink health"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "2"  "cache-cleanup"      "Clear caches (Library, npm, pnpm)"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "3"  "low-disk-alert"     "Check internal Mac free space"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "7"  "duplicate-finder"   "Scan SSD for duplicate files"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "8"  "large-file-tracker" "Weekly large file report"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "12" "ssd-health"         "SSD space + fill prediction"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "23" "auto-eject"         "Eject / mount / status SSD"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "24" "folder-dashboard"   "Live SSD size dashboard"
  echo -e "  ${DIM}└──────┴──────────────────────┴────────────────────────────────────────┘${RESET}"

  echo ""

  # Section: Dev
  echo -e "  ${YELLOW}${BOLD}  DEV & CODE${RESET}"
  echo -e "  ${DIM}┌──────┬──────────────────────┬────────────────────────────────────────┐${RESET}"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "4"  "node-modules"       "Find/delete stale node_modules"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "5"  "dev-backup"         "Rsync active projects to backup"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "9"  "git-status"         "Uncommitted changes across projects"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "10" "stale-branches"     "Delete merged git branches"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "11" "dep-audit"          "npm vulnerability scan"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "15" "project-switcher"   "Open project in VS Code"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "20" "env-backup"         "Backup all .env files"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "21" "port-resolver"      "Scan ports 3000-3010"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "22" "dep-updater"        "npm update + commit all projects"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "16" "daily-dev-log"      "Create today's dev log files"
  echo -e "  ${DIM}└──────┴──────────────────────┴────────────────────────────────────────┘${RESET}"

  echo ""

  # Section: System
  echo -e "  ${YELLOW}${BOLD}  SYSTEM & MONITORING${RESET}"
  echo -e "  ${DIM}┌──────┬──────────────────────┬────────────────────────────────────────┐${RESET}"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "13" "startup-optimizer"  "Kill memory hogs on login"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "17" "app-usage"          "Show today's app usage report"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "18" "ram-monitor"        "Check RAM + kill heaviest process"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "19" "battery-logger"     "Log battery health + cycles"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "6"  "serial-lock"        "Check this Mac is authorised"
  echo -e "  ${DIM}└──────┴──────────────────────┴────────────────────────────────────────┘${RESET}"

  echo ""

  # Section: Productivity
  echo -e "  ${YELLOW}${BOLD}  PRODUCTIVITY${RESET}"
  echo -e "  ${DIM}┌──────┬──────────────────────┬────────────────────────────────────────┐${RESET}"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "14" "screenshot-org"     "Move screenshots off Desktop"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "25" "focus-mode"         "Block distractions (25min default)"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "26" "meeting-prep"       "Prep workspace for meeting"
  echo -e "  ${DIM}└──────┴──────────────────────┴────────────────────────────────────────┘${RESET}"

  echo ""
  echo -e "  ${DIM}Enter number or name  •  q to quit${RESET}"
  echo ""
  echo -ne "  ${CYAN}❯${RESET} "
}

run_script() {
  local input="$1"
  local entry=""

  # Match by number or name
  for item in "${MENU[@]}"; do
    num=$(echo $item | cut -d: -f1)
    name=$(echo $item | cut -d: -f2)
    if [[ "$input" == "$num" ]] || [[ "$input" == "$name" ]]; then
      entry="$item"
      break
    fi
  done

  if [ -z "$entry" ]; then
    echo "  ❌ Not found: $input"
    return
  fi

  script_and_args=$(echo $entry | cut -d: -f4-)
  script=$(echo $script_and_args | awk '{print $1}')
  args=$(echo $script_and_args | cut -s -d' ' -f2-)

  echo ""
  echo "  ▶ Running $script $args"
  echo "  ─────────────────────────────────────"
  eval "$SCRIPTS_DIR/$script $args"
  echo ""
  echo -n "  Press Enter to return to menu..."
  read
}

# Direct call: ssd <number or name>
if [ -n "$1" ]; then
  run_script "$1"
  exit 0
fi

# Interactive menu
while true; do
  print_menu
  read choice
  [[ "$choice" == "q" ]] && echo "  Bye." && exit 0
  [[ -z "$choice" ]] && continue
  run_script "$choice"
done
