#!/bin/zsh
# mac-ssd-toolkit — Uninstaller

RESET='\033[0m'; BOLD='\033[1m'; RED='\033[31m'; GREEN='\033[32m'

echo -e "${RED}${BOLD}Uninstalling mac-ssd-toolkit...${RESET}"
echo ""

USERNAME=$(whoami)

# Unload + remove LaunchAgents
for plist in ~/Library/LaunchAgents/com.$USERNAME.*.plist; do
  launchctl unload "$plist" 2>/dev/null
  rm -f "$plist"
done
echo -e "${GREEN}✓ LaunchAgents removed${RESET}"

# Remove aliases from .zshrc
sed -i '' '/# mac-ssd-toolkit/,/^$/d' ~/.zshrc 2>/dev/null
echo -e "${GREEN}✓ Aliases removed from .zshrc${RESET}"

echo ""
echo -e "${BOLD}Done. The scripts folder on your SSD was NOT deleted.${RESET}"
echo "Remove manually: rm -rf <SSD>/Dev/mac-ssd-toolkit"
