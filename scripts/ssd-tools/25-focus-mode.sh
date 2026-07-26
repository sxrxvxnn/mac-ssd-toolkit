#!/bin/zsh
# Focus mode — kills distractions, blocks sites for set duration

DURATION=${1:-25}  # minutes, default 25 (Pomodoro)
HOSTS="/etc/hosts"
BLOCK_MARKER="# focus-mode-block"

DISTRACTING_APPS=(
  "Discord"
  "Spotify"
  "WhatsApp"
  "Telegram"
  "Messages"
)

BLOCK_SITES=(
  "twitter.com"
  "x.com"
  "instagram.com"
  "reddit.com"
  "youtube.com"
  "facebook.com"
)

start_focus() {
  echo "🎯 Focus mode ON — ${DURATION} minutes"

  # Kill distracting apps
  for app in "${DISTRACTING_APPS[@]}"; do
    pkill -x "$app" 2>/dev/null && echo "  ✓ Closed $app"
  done

  # Block sites
  echo "\n$BLOCK_MARKER" | sudo tee -a "$HOSTS" > /dev/null
  for site in "${BLOCK_SITES[@]}"; do
    echo "127.0.0.1 $site www.$site $BLOCK_MARKER" | sudo tee -a "$HOSTS" > /dev/null
    echo "  🚫 Blocked $site"
  done
  sudo dscacheutil -flushcache 2>/dev/null

  # Set DND
  osascript -e 'tell application "System Events" to tell process "Control Center" to tell menu bar item "Control Center" of menu bar 1 to click' 2>/dev/null

  osascript -e "display notification \"Focus mode active for ${DURATION} minutes. Distractions blocked.\" with title \"🎯 Focus Mode ON\""

  # Auto-end after duration
  sleep $((DURATION * 60))
  end_focus
}

end_focus() {
  echo "⏰ Focus mode OFF"

  # Unblock sites
  sudo sed -i '' "/$BLOCK_MARKER/d" "$HOSTS" 2>/dev/null
  sudo dscacheutil -flushcache 2>/dev/null
  echo "  ✅ Sites unblocked"

  osascript -e "display notification \"Focus session complete! Great work.\" with title \"✅ Focus Mode OFF\" sound name \"Glass\""
}

case "${2:-start}" in
  stop) end_focus ;;
  *)    start_focus ;;
esac
