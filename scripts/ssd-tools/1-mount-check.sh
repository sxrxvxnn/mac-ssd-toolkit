#!/bin/zsh
# Runs at login — warns if SSD isn't mounted

SSD="{{SSD_MOUNT}}"
SYMLINKS=(Desktop Documents Downloads Movies leadgen-platform linkedin_automate lead-engine marvel-portfolio RESUME)

if [ ! -d "$SSD" ]; then
  osascript -e 'display notification "SSD not mounted! Symlinks are broken. Plug in your SSD." with title "⚠️ SSD Missing" sound name "Basso"'
  echo "❌ SSD not mounted at $SSD"
  exit 1
fi

broken=()
for link in "${SYMLINKS[@]}"; do
  target="$HOME/$link"
  if [ -L "$target" ] && [ ! -e "$target" ]; then
    broken+=("$link")
  fi
done

if [ ${#broken[@]} -gt 0 ]; then
  osascript -e "display notification \"Broken symlinks: ${broken[*]}\" with title \"⚠️ SSD Symlink Issue\" sound name \"Basso\""
  echo "❌ Broken symlinks: ${broken[*]}"
  exit 1
fi

echo "✅ SSD mounted and all symlinks healthy"
