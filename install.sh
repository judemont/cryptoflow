#!/bin/bash

APP_NAME="CryptoFlow"
EXECUTABLE_NAME="cryptoflow"
GITHUB_ZIP_URL="https://github.com/youruser/yourrepo/releases/latest/download/cryptoflow.zip"

TMP_DIR="/tmp/${APP_NAME}_install"
INSTALL_PATH="/opt/$APP_NAME"
DESKTOP_FILE="/usr/share/applications/$APP_NAME.desktop"
ICON_NAME="$APP_NAME"

mkdir -p "$TMP_DIR"
echo "Downloading the app from GitHub..."
curl -L "$GITHUB_ZIP_URL" -o "$TMP_DIR/app.zip"

echo "Extracting the bundle..."
unzip -q "$TMP_DIR/app.zip" -d "$TMP_DIR/unzipped"

BUNDLE_PATH=$(find "$TMP_DIR/unzipped" -type d -name bundle | head -n 1)
if [ ! -d "$BUNDLE_PATH" ]; then
    echo "Error: Bundle not found in the archive."
    exit 1
fi

echo "Installing to $INSTALL_PATH..."
sudo mkdir -p "$INSTALL_PATH"
sudo cp -r "$BUNDLE_PATH"/* "$INSTALL_PATH/"
sudo chmod +x "$INSTALL_PATH/$EXECUTABLE_NAME"

ICON_SRC=$(find "$INSTALL_PATH" -iname "*.png" | head -n 1)
if [ -f "$ICON_SRC" ]; then
    sudo cp "$ICON_SRC" "/usr/share/pixmaps/$ICON_NAME.png"
    ICON_REF="/usr/share/pixmaps/$ICON_NAME.png"
else
    ICON_REF="utilities-terminal"
fi

echo "Creating .desktop launcher..."
echo "[Desktop Entry]
Name=$APP_NAME
Comment=Track crypto prices in style and privacy with CryptoFlow
Exec=$INSTALL_PATH/$EXECUTABLE_NAME
Icon=$ICON_REF
Type=Application
Categories=Utility;Finance;
Terminal=false
" | sudo tee "$DESKTOP_FILE" > /dev/null

sudo chmod +x "$DESKTOP_FILE"
sudo update-desktop-database > /dev/null 2>&1

echo "Cleaning up..."
rm -rf "$TMP_DIR"

echo "$APP_NAME has been installed and can be launched from your application menu."
