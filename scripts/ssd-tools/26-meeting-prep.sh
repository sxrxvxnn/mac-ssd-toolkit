#!/bin/zsh
# Meeting prep — closes clutter, opens project, sets DND

PROJECT=${1:-"leadgen-platform"}
DEV_DIR="{{SSD_MOUNT}}/Dev"

echo "📅 Meeting prep for $PROJECT..."

# Close clutter apps
CLOSE_APPS=("Discord" "Spotify" "WhatsApp" "Telegram" "Finder")
for app in "${CLOSE_APPS[@]}"; do
  osascript -e "tell application \"$app\" to quit" 2>/dev/null && echo "  ✓ Closed $app"
done

# Close all terminal tabs except current
# Open project in VS Code
if [ -d "$DEV_DIR/$PROJECT" ]; then
  code "$DEV_DIR/$PROJECT" 2>/dev/null && echo "  ✓ Opened $PROJECT in VS Code"
fi

# Open Chrome in clean window
osascript -e 'tell application "Google Chrome" to make new window' 2>/dev/null
echo "  ✓ Fresh Chrome window"

# Set Do Not Disturb via focus
osascript << 'EOF'
tell application "System Events"
  tell process "Control Center"
    key code 100
  end tell
end tell
EOF

# Run git status for the project
echo ""
echo "📋 Current git status:"
cd "$DEV_DIR/$PROJECT" && git status --short 2>/dev/null | head -10

echo ""
echo "✅ Ready for meeting — $PROJECT loaded"
osascript -e "display notification \"$PROJECT loaded. DND on. Ready.\" with title \"📅 Meeting Prep Done\""
