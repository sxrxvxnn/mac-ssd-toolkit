#!/bin/zsh
# mac-ssd-toolkit — Interactive Installer

RESET='\033[0m'; BOLD='\033[1m'; CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; DIM='\033[2m'

clear
echo -e "${CYAN}${BOLD}"
echo "  ╔═══════════════════════════════════════════════════════════════╗"
echo "  ║                                                               ║"
echo "  ║              mac-ssd-toolkit — Installer                     ║"
echo "  ║                                                               ║"
echo "  ╚═══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo ""

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Gather info ---
echo -e "  ${YELLOW}Let's set up your toolkit.${RESET}"
echo ""

# Username
CURRENT_USER=$(whoami)
echo -ne "  Mac username [${CURRENT_USER}]: "
read input_user
USERNAME="${input_user:-$CURRENT_USER}"

# SSD mount point
echo ""
echo -e "  ${DIM}Mounted volumes:${RESET}"
ls /Volumes/ | grep -v "^Macintosh" | awk '{print "    /Volumes/"$1}'
echo ""
echo -ne "  SSD volume name (e.g. 007): "
read SSD_NAME
SSD_MOUNT="/Volumes/$SSD_NAME"

if [ ! -d "$SSD_MOUNT" ]; then
  echo -e "  ${RED}⚠ $SSD_MOUNT not found. Plug in your SSD and re-run.${RESET}"
  exit 1
fi

# Mac serial (auto-detect)
MAC_SERIAL=$(system_profiler SPHardwareDataType 2>/dev/null | grep "Serial Number" | awk '{print $NF}')
echo ""
echo -ne "  Mac serial [${MAC_SERIAL}]: "
read input_serial
MAC_SERIAL="${input_serial:-$MAC_SERIAL}"

# Dev projects
echo ""
echo -ne "  Dev project names (comma-separated, e.g. my-app,portfolio): "
read projects_input
IFS=',' read -rA DEV_PROJECTS <<< "$projects_input"

echo ""
echo -e "  ${DIM}Install location: ${SSD_MOUNT}/Dev/mac-ssd-toolkit${RESET}"
echo -ne "  ${CYAN}Proceed? (y/n): ${RESET}"
read confirm
[[ "$confirm" != "y" ]] && echo "  Cancelled." && exit 0

echo ""
echo -e "  ${BOLD}Installing...${RESET}"
echo ""

# --- Create directories ---
INSTALL_DIR="$SSD_MOUNT/Dev/mac-ssd-toolkit"
mkdir -p "$INSTALL_DIR/scripts/ssd-tools" "$INSTALL_DIR/scripts/mac-tools" "$INSTALL_DIR/logs"

# --- Copy + substitute scripts ---
for f in "$REPO_DIR/scripts/ssd-tools/"*.sh; do
  out="$INSTALL_DIR/scripts/ssd-tools/$(basename $f)"
  sed \
    "s|{{SSD_MOUNT}}|$SSD_MOUNT|g; s|{{USERNAME}}|$USERNAME|g; s|{{MAC_SERIAL}}|$MAC_SERIAL|g" \
    "$f" > "$out"
  chmod +x "$out"
done
echo -e "  ${GREEN}✓ SSD scripts installed${RESET}"

sed \
  "s|{{SSD_MOUNT}}|$SSD_MOUNT|g; s|{{USERNAME}}|$USERNAME|g" \
  "$REPO_DIR/scripts/mac-tools/mac.sh" > "$INSTALL_DIR/scripts/mac-tools/mac.sh"
chmod +x "$INSTALL_DIR/scripts/mac-tools/mac.sh"
echo -e "  ${GREEN}✓ Mac menu installed${RESET}"

# --- Dev backup project list ---
PROJECTS_ARRAY=$(printf '  "%s"\n' "${DEV_PROJECTS[@]}")
sed -i '' "s|project-one\|project-two|${DEV_PROJECTS[*]}|" \
  "$INSTALL_DIR/scripts/ssd-tools/5-dev-backup.sh" 2>/dev/null

# --- Install LaunchAgents ---
AGENTS_DIR=~/Library/LaunchAgents
for plist in "$REPO_DIR/agents/"*.plist; do
  basename=$(basename "$plist")
  newname="${basename/com.{{USERNAME}}./com.$USERNAME.}"
  out="$AGENTS_DIR/$newname"
  sed \
    "s|{{SSD_MOUNT}}|$SSD_MOUNT|g; s|{{USERNAME}}|$USERNAME|g" \
    "$plist" > "$out"
  launchctl unload "$out" 2>/dev/null
  launchctl load "$out" 2>/dev/null
done
echo -e "  ${GREEN}✓ LaunchAgents installed + loaded${RESET}"

# --- Add aliases to .zshrc ---
ZSHRC="$HOME/.zshrc"
if ! grep -q "mac-ssd-toolkit" "$ZSHRC" 2>/dev/null; then
cat >> "$ZSHRC" << EOF

# mac-ssd-toolkit
alias ssd="$INSTALL_DIR/scripts/ssd-tools/ssd.sh"
alias mac="$INSTALL_DIR/scripts/mac-tools/mac.sh"
alias dev="cd $SSD_MOUNT/Dev"
alias gs="git status"
alias ga="git add -A"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline -10"
alias reload="source ~/.zshrc && echo '✓ reloaded'"
alias freeup="$INSTALL_DIR/scripts/ssd-tools/2-cache-cleanup.sh"
alias backup="$INSTALL_DIR/scripts/ssd-tools/5-dev-backup.sh"
alias focus="$INSTALL_DIR/scripts/ssd-tools/25-focus-mode.sh"
EOF
fi
echo -e "  ${GREEN}✓ Aliases added to .zshrc${RESET}"

# --- Save config ---
cat > "$INSTALL_DIR/config/config.sh" << EOF
export TOOLKIT_USERNAME="$USERNAME"
export TOOLKIT_SSD_MOUNT="$SSD_MOUNT"
export TOOLKIT_MAC_SERIAL="$MAC_SERIAL"
export TOOLKIT_SSD_NAME="$SSD_NAME"
EOF
echo -e "  ${GREEN}✓ Config saved${RESET}"

echo ""
echo -e "  ${CYAN}${BOLD}✅ Installation complete!${RESET}"
echo ""
echo -e "  Run ${BOLD}source ~/.zshrc${RESET} then type ${BOLD}ssd${RESET} or ${BOLD}mac${RESET} to get started."
echo ""
