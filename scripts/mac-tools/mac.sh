#!/bin/zsh
# Mac Tools Menu

SCRIPTS_DIR="/Volumes/007/Dev/scripts/mac-tools"

print_menu() {
  clear

  local RESET='\033[0m'
  local BOLD='\033[1m'
  local DIM='\033[2m'
  local CYAN='\033[36m'
  local YELLOW='\033[33m'
  local GREEN='\033[32m'

  echo -e "${CYAN}${BOLD}"
  echo "  ╔═══════════════════════════════════════════════════════════════════════╗"
  echo "  ║                                                                       ║"
  echo "  ║                    ◈  MAC TOOLS — SHRAVAN  ◈                         ║"
  echo "  ║                                                                       ║"
  echo "  ╚═══════════════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"

  CPU=$(top -l 1 -s 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%')
  BATTERY=$(pmset -g batt | grep -o '[0-9]*%' | head -1)
  CHARGING=$(pmset -g batt | grep -o 'charging\|discharging\|charged' | head -1)
  UPTIME=$(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | xargs)
  WIFI=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' '{print $2}')
  IP=$(ipconfig getifaddr en0 2>/dev/null || echo "no wifi")

  echo -e "  ${DIM}┌─────────────────────────────────────────────────────────────────────┐${RESET}"
  echo -e "  ${DIM}│${RESET}  ${GREEN}CPU${RESET} ${BOLD}${CPU}%${RESET}   ${CYAN}Battery${RESET} ${BOLD}${BATTERY}${RESET} ${DIM}(${CHARGING})${RESET}   ${YELLOW}Uptime${RESET} ${BOLD}${UPTIME}${RESET}  ${DIM}│${RESET}"
  echo -e "  ${DIM}│${RESET}  ${GREEN}Wifi${RESET} ${BOLD}${WIFI}${RESET}   ${CYAN}IP${RESET} ${BOLD}${IP}${RESET}  ${DIM}│${RESET}"
  echo -e "  ${DIM}└─────────────────────────────────────────────────────────────────────┘${RESET}"
  echo ""

  echo -e "  ${YELLOW}${BOLD}  SYSTEM${RESET}"
  echo -e "  ${DIM}┌──────┬──────────────────────┬────────────────────────────────────────┐${RESET}"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "1"  "system-stats"      "Live CPU, RAM, disk, network"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "2"  "battery-health"    "Battery cycles, capacity, health"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "3"  "wifi-info"         "Wifi network, IP, signal"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "4"  "running-processes" "Top 10 CPU + RAM hogs"
  echo -e "  ${DIM}└──────┴──────────────────────┴────────────────────────────────────────┘${RESET}"
  echo ""

  echo -e "  ${YELLOW}${BOLD}  APPS${RESET}"
  echo -e "  ${DIM}┌──────┬──────────────────────┬────────────────────────────────────────┐${RESET}"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "5"  "kill-hogs"         "Kill top 3 memory hogs"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "6"  "app-usage"         "Today's app usage report"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "7"  "startup-items"     "List all login startup agents"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "8"  "force-quit"        "Force quit a frozen app by name"
  echo -e "  ${DIM}└──────┴──────────────────────┴────────────────────────────────────────┘${RESET}"
  echo ""

  echo -e "  ${YELLOW}${BOLD}  MAINTENANCE${RESET}"
  echo -e "  ${DIM}┌──────┬──────────────────────┬────────────────────────────────────────┐${RESET}"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "9"  "clear-caches"      "Clear Library, npm, pip caches"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "10" "brew-update"       "Brew update + upgrade + cleanup"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "11" "run-all-agents"    "Trigger all shravan LaunchAgents"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "12" "large-files"       "Find files over 500MB on Mac"
  echo -e "  ${DIM}└──────┴──────────────────────┴────────────────────────────────────────┘${RESET}"
  echo ""

  echo -e "  ${YELLOW}${BOLD}  SECURITY${RESET}"
  echo -e "  ${DIM}┌──────┬──────────────────────┬────────────────────────────────────────┐${RESET}"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "13" "firewall-status"   "Check firewall + stealth mode"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "14" "open-ports"        "Scan all listening ports"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "15" "lock-screen"       "Lock Mac screen immediately"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "16" "ssh-keys"          "List SSH keys + fingerprints"
  echo -e "  ${DIM}└──────┴──────────────────────┴────────────────────────────────────────┘${RESET}"
  echo ""

  echo -e "  ${YELLOW}${BOLD}  POWER${RESET}"
  echo -e "  ${DIM}┌──────┬──────────────────────┬────────────────────────────────────────┐${RESET}"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "17" "caffeinate"        "Prevent sleep (default 2hrs)"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "18" "sleep-timer"       "Sleep Mac after N minutes"
  printf "  ${DIM}│${RESET} ${CYAN}%2s${RESET}   ${DIM}│${RESET}  ${BOLD}%-20s${RESET}${DIM}│${RESET}  %-38s${DIM}│${RESET}\n" "19" "battery-saver"     "Toggle low power mode on/off"
  echo -e "  ${DIM}└──────┴──────────────────────┴────────────────────────────────────────┘${RESET}"

  echo ""
  echo -e "  ${DIM}Enter number or name  •  q to quit${RESET}"
  echo ""
  echo -ne "  ${CYAN}❯${RESET} "
}

run_action() {
  local input="$1"
  echo ""
  case "$input" in
    1|system-stats)
      echo "  ▶ System Stats"
      echo "  ─────────────────────────────────────"
      top -l 1 -s 0 | grep -E "CPU usage|Load Avg|PhysMem"
      echo ""
      df -h / /Volumes/007 2>/dev/null | awk 'NR==1{print "  "$0} NR>1{printf "  %-20s used:%-8s free:%s\n", $9, $3, $4}'
      ;;
    2|battery-health)
      echo "  ▶ Battery Health"
      echo "  ─────────────────────────────────────"
      system_profiler SPPowerDataType 2>/dev/null | grep -E "Cycle Count|Condition|Maximum Capacity|Charging|Full Charge"
      pmset -g batt
      ;;
    3|wifi-info)
      echo "  ▶ Wifi Info"
      echo "  ─────────────────────────────────────"
      networksetup -getairportnetwork en0
      echo "  Local IP : $(ipconfig getifaddr en0 2>/dev/null)"
      echo "  Public IP: $(curl -s --max-time 5 ifconfig.me 2>/dev/null)"
      /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I 2>/dev/null | grep -E "SSID|agrCtlRSSI|channel|lastTxRate"
      ;;
    4|running-processes)
      echo "  ▶ Top Processes"
      echo "  ─────────────────────────────────────"
      echo "  -- Top CPU --"
      ps aux | sort -rk3 | awk 'NR>=2 && NR<=6 {printf "  %-35s CPU:%-6s RAM:%s%%\n", $11, $3, $4}'
      echo ""
      echo "  -- Top RAM --"
      ps aux | sort -rk4 | awk 'NR>=2 && NR<=6 {printf "  %-35s RAM:%-6s CPU:%s%%\n", $11, $4, $3}'
      ;;
    5|kill-hogs)
      echo "  ▶ Kill Memory Hogs"
      echo "  ─────────────────────────────────────"
      ps aux | sort -rk4 | awk 'NR>=2 && NR<=4 {print $2, $4, $11}' | while read pid mem name; do
        echo "  Killing $name (RAM: ${mem}%)"
        kill -9 $pid 2>/dev/null && echo "  ✓ killed" || echo "  ⚠ failed (protected)"
      done
      ;;
    6|app-usage)
      echo "  ▶ App Usage Report"
      echo "  ─────────────────────────────────────"
      /Volumes/007/Dev/scripts/ssd-tools/17-app-usage-tracker.sh --report 2>/dev/null
      ;;
    7|startup-items)
      echo "  ▶ Startup Agents"
      echo "  ─────────────────────────────────────"
      echo "  -- Your agents (com.shravan.*) --"
      launchctl list | grep shravan | awk '{printf "  %-42s exit:%s\n", $3, $1}'
      echo ""
      echo "  -- Third party --"
      ls ~/Library/LaunchAgents/ | grep -v "^com.shravan\|^com.apple\|^homebrew"
      ;;
    8|force-quit)
      echo -ne "  App name to force quit: "
      read appname
      pkill -ix "$appname" 2>/dev/null && echo "  ✓ $appname killed" || echo "  ⚠ $appname not found"
      ;;
    9|clear-caches)
      echo "  ▶ Clearing Caches"
      echo "  ─────────────────────────────────────"
      /Volumes/007/Dev/scripts/ssd-tools/2-cache-cleanup.sh
      ;;
    10|brew-update)
      echo "  ▶ Brew Update + Upgrade + Cleanup"
      echo "  ─────────────────────────────────────"
      brew update && brew upgrade && brew cleanup
      echo "  ✅ Brew fully updated"
      ;;
    11|run-all-agents)
      echo "  ▶ Triggering all shravan agents"
      echo "  ─────────────────────────────────────"
      for plist in ~/Library/LaunchAgents/com.shravan.*.plist; do
        name=$(basename $plist .plist)
        launchctl kickstart -k "gui/$(id -u)/$name" 2>/dev/null && echo "  ✓ $name" || echo "  ⚠ $name"
      done
      ;;
    12|large-files)
      echo "  ▶ Large Files on Mac Internal (>500MB)"
      echo "  ─────────────────────────────────────"
      find ~ -not -path "*/Volumes/*" -not -path "*/.Trash/*" -not -path "*/Library/CloudStorage/*" -size +500M -maxdepth 6 2>/dev/null | while read f; do
        du -sh "$f" 2>/dev/null
      done
      echo "  Done."
      ;;
    13|firewall-status)
      echo "  ▶ Firewall Status"
      echo "  ─────────────────────────────────────"
      /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
      /usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode
      ;;
    14|open-ports)
      echo "  ▶ Listening Ports"
      echo "  ─────────────────────────────────────"
      lsof -i -P 2>/dev/null | grep LISTEN | awk '{printf "  %-25s %s\n", $1, $9}' | sort -u
      ;;
    15|lock-screen)
      echo "  ▶ Locking screen..."
      osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
      ;;
    16|ssh-keys)
      echo "  ▶ SSH Keys"
      echo "  ─────────────────────────────────────"
      ls -la ~/.ssh/ 2>/dev/null | grep -v "^total\|^\.\."
      echo ""
      for key in ~/.ssh/*.pub; do
        [ -f "$key" ] && echo "  $(ssh-keygen -l -f "$key" 2>/dev/null)"
      done
      ;;
    17|caffeinate)
      DURATION=${2:-7200}
      echo "  ▶ Caffeinating for $((DURATION/60)) minutes..."
      caffeinate -d -t $DURATION &
      echo "  ✓ Sleep prevented — PID $! — kill it with: kill $!"
      ;;
    18|sleep-timer)
      echo -ne "  Sleep after how many minutes? "
      read mins
      (sleep $((mins*60)) && pmset sleepnow) &
      echo "  ✓ Mac sleeps in ${mins} minutes (PID $!)"
      ;;
    19|battery-saver)
      CURRENT=$(pmset -g | grep lowpowermode | awk '{print $2}')
      if [ "$CURRENT" = "1" ]; then
        osascript -e 'tell application "System Events" to tell process "System Preferences" to set value of checkbox 1 of window 1 to false' 2>/dev/null
        launchctl asuser $(id -u) sudo pmset -a lowpowermode 0 2>/dev/null || \
          open "x-apple.systempreferences:com.apple.preference.battery"
        echo "  ✓ Low power mode toggled OFF (or Battery prefs opened)"
      else
        open "x-apple.systempreferences:com.apple.preference.battery"
        echo "  ✓ Battery prefs opened — toggle Low Power Mode there"
      fi
      ;;
    *)
      echo "  ❌ Not found: $input"
      ;;
  esac
  echo ""
  echo -n "  Press Enter to return to menu..."
  read
}

# Direct call: mac <number or name>
if [ -n "$1" ]; then
  run_action "$1" "$2"
  exit 0
fi

# Interactive menu
while true; do
  print_menu
  read choice
  [[ "$choice" == "q" ]] && echo "  Bye." && exit 0
  [[ -z "$choice" ]] && continue
  run_action "$choice"
done
