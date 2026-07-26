#!/bin/zsh
# Safe eject SSD on sleep, remount on wake

ACTION="${1:-status}"

case "$ACTION" in
  eject)
    echo "💤 Mac sleeping — ejecting SSD..."
    diskutil eject disk5 2>/dev/null && echo "✅ SSD safely ejected" || echo "⚠️ Eject failed"
    ;;
  mount)
    echo "☀️ Mac waking — mounting SSD..."
    sleep 2
    diskutil mount disk5s1 2>/dev/null && echo "✅ SSD mounted" || echo "⚠️ Mount failed"
    # Re-run mount check after mount
    {{SSD_MOUNT}}/Dev/scripts/ssd-tools/1-mount-check.sh
    ;;
  status)
    if [ -d "{{SSD_MOUNT}}" ]; then
      echo "✅ SSD mounted at {{SSD_MOUNT}}"
    else
      echo "❌ SSD not mounted"
    fi
    ;;
esac
