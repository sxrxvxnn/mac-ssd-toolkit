#!/bin/zsh
# Auto-moves screenshots from Desktop to Media/Photos/Screenshots/

DESKTOP="{{SSD_MOUNT}}/Desktop"
DEST="{{SSD_MOUNT}}/Media/Photos/Screenshots"
mkdir -p "$DEST"

COUNT=0
while IFS= read -r file; do
  filename=$(basename "$file")
  mv "$file" "$DEST/$filename" && COUNT=$((COUNT + 1))
done < <(find "$DESKTOP" -maxdepth 1 -type f \( -name "Screenshot*" -o -name "Screen Shot*" \) 2>/dev/null)

if [ "$COUNT" -gt 0 ]; then
  echo "✅ Moved $COUNT screenshot(s) → $DEST"
  osascript -e "display notification \"Moved $COUNT screenshots to Media/Photos/Screenshots\" with title \"📸 Screenshots Organized\""
else
  echo "✅ No screenshots on Desktop"
fi
