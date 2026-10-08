#!/usr/bin/env sh
# Creates an application-menu entry + Desktop icon for Smart Calculator
DIR="$(cd "$(dirname "$0")" && pwd)"
URL="$(head -n1 "$DIR/app-url.txt" | tr -d '\r')"
ICON_DIR="$HOME/.local/share/icons"; APP_DIR="$HOME/.local/share/applications"
mkdir -p "$ICON_DIR" "$APP_DIR"
cp "$DIR/icon-512.png" "$ICON_DIR/smart-calculator.png"
BROWSER=""
for b in google-chrome chromium chromium-browser microsoft-edge brave-browser; do
  command -v "$b" >/dev/null 2>&1 && BROWSER="$b" && break
done
if [ -n "$BROWSER" ]; then EXEC="$BROWSER --app=$URL"; else EXEC="xdg-open $URL"; fi
FILE="$APP_DIR/smart-calculator.desktop"
cat > "$FILE" <<EOT
[Desktop Entry]
Type=Application
Name=Smart Calculator
Name[ar]=الحاسبة الشاملة
Exec=$EXEC
Icon=$ICON_DIR/smart-calculator.png
Categories=Utility;Calculator;
Terminal=false
EOT
chmod +x "$FILE"
DESK="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"
if [ -d "$DESK" ]; then cp "$FILE" "$DESK/"; chmod +x "$DESK/smart-calculator.desktop"; gio set "$DESK/smart-calculator.desktop" metadata::trusted true 2>/dev/null; fi
echo "Done. Smart Calculator added to the menu and Desktop."
