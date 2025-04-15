#!/bin/bash

APP_NAME="CryptoFlow"
EXECUTABLE_NAME="cryptoflow"
GITHUB_ZIP_URL="https://github.com/judemont/cryptoflow/releases/latest/download/cryptoflow.zip"

TMP_DIR="/tmp/${APP_NAME}_install"
INSTALL_PATH="$HOME/.local/share/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
ICON_NAME="$APP_NAME"

mkdir -p "$TMP_DIR"
echo "Downloading the app from GitHub..."
curl -L "$GITHUB_ZIP_URL" -o "$TMP_DIR/app.zip"

echo "Extracting the bundle..."
unzip -q "$TMP_DIR/app.zip" -d "$TMP_DIR/unzipped"

BUNDLE_PATH=$(find "$TMP_DIR/unzipped" -type d -name bundle | head -n 1)
if [ ! -d "$BUNDLE_PATH" ]; then
    echo "Error: Bundle not found in the archive. Installing from root folder..."
    BUNDLE_PATH="$TMP_DIR/unzipped"
fi

echo "Installing to $INSTALL_PATH..."
mkdir -p "$INSTALL_PATH"
cp -r "$BUNDLE_PATH"/* "$INSTALL_PATH/"
chmod +x "$INSTALL_PATH/$EXECUTABLE_NAME"

ICON_SRC=$(find "$INSTALL_PATH" -iname "*.png" | head -n 1)
if [ -f "$ICON_SRC" ]; then
    ICON_DEST="$HOME/.local/share/icons/$ICON_NAME.png"
    mkdir -p "$(dirname "$ICON_DEST")"
    cp "$ICON_SRC" "$ICON_DEST"
    ICON_REF="$ICON_DEST"
else
    ICON_REF="utilities-terminal"
fi

echo "Creating .desktop launcher..."
mkdir -p "$(dirname "$DESKTOP_FILE")"
echo "[Desktop Entry]
Name=$APP_NAME
Comment=Track crypto prices in style and privacy with CryptoFlow
Exec=$INSTALL_PATH/$EXECUTABLE_NAME
Icon=$ICON_REF
Type=Application
Categories=Utility;Finance;
Terminal=false
" > "$DESKTOP_FILE"

chmod +x "$DESKTOP_FILE"
update-desktop-database "$HOME/.local/share/applications" > /dev/null 2>&1

echo "Cleaning up..."
rm -rf "$TMP_DIR"

echo "$APP_NAME has been installed and can be launched from your application menu. Enjoy !"
