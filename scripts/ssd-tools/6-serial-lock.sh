#!/bin/zsh
# Ejects SSD if not running on the authorised Mac

AUTHORISED_SERIAL="{{MAC_SERIAL}}"
SSD_DISK="disk5"
SSD_VOLUME="{{SSD_MOUNT}}"

CURRENT_SERIAL=$(system_profiler SPHardwareDataType 2>/dev/null | awk '/Serial Number \(system\)/ {print $NF}')

if [ "$CURRENT_SERIAL" != "$AUTHORISED_SERIAL" ]; then
  # Unauthorised Mac — eject immediately
  osascript -e 'display alert "Unauthorised Mac" message "This SSD is locked to another Mac. Ejecting now." as critical buttons {"OK"} default button "OK"'
  diskutil eject "$SSD_DISK" 2>/dev/null
  exit 1
fi

echo "✅ Authorised Mac ($CURRENT_SERIAL) — access granted"
