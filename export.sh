#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TITLE="$(basename "$SCRIPT_DIR")"
COLOR="#000000"

rm -f "$SCRIPT_DIR/export/win/"*.*
rm -f "$SCRIPT_DIR/export/web/"*.*
rm -f "$SCRIPT_DIR/export/"*.*
mkdir -p "$SCRIPT_DIR/export"
mkdir -p "$SCRIPT_DIR/export/web"
mkdir -p "$SCRIPT_DIR/export/win"

# Love file.
cd "$SCRIPT_DIR/main"
zip -qr9 "$SCRIPT_DIR/export/$TITLE.love" "."

# Web page.
cp "$SCRIPT_DIR/resources/web-template/"* "$SCRIPT_DIR/export/web/"
cp "$SCRIPT_DIR/export/$TITLE.love" "$SCRIPT_DIR/export/web/game.love"
sed -i -e "s/__COLOR/$COLOR/g" "$SCRIPT_DIR/export/web/style.css"
sed -i -e "s/__TITLE/$TITLE/g" "$SCRIPT_DIR/export/web/index.html"

# Web zip.
cd "$SCRIPT_DIR/export/web"
zip -qr9 "$SCRIPT_DIR/export/$TITLE-web.zip" "."

# Windows executable.
cp "$SCRIPT_DIR/resources/love-11.5-win32/"* "$SCRIPT_DIR/export/win/"
mv "$SCRIPT_DIR/export/win/love.exe" "$SCRIPT_DIR/export/win/$TITLE.exe"
cat "$SCRIPT_DIR/export/$TITLE.love" >> "$SCRIPT_DIR/export/win/$TITLE.exe"

# Windows zip.
cd "$SCRIPT_DIR/export/win"
zip -qr9 "$SCRIPT_DIR/export/$TITLE-win.zip" "."
