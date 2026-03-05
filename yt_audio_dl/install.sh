#!/bin/bash

# Define paths
APP_DIR="$HOME/.local/share/yt_audio_dl"
BIN_NAME="yt_audio_dl"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/yt_audio_dl.desktop"

echo "Installing YouTube Audio Downloader..."

# Check if the build exists
if [ ! -d "build/linux/x64/release/bundle" ]; then
    echo "Error: Build directory not found. Please run 'flutter build linux --release' first."
    exit 1
fi

# Create app directory and copy bundled files
mkdir -p "$APP_DIR"
cp -r build/linux/x64/release/bundle/* "$APP_DIR/"

# Create desktop entry for the application launcher (KDE Plasma, GNOME, etc.)
mkdir -p "$DESKTOP_DIR"
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=YT Audio Downloader
Comment=Download YouTube videos as audio
Exec="$APP_DIR/$BIN_NAME"
Icon=media-playback-start
Terminal=false
Categories=AudioVideo;Audio;Network;
EOF

# Make the desktop entry executable
chmod +x "$DESKTOP_FILE"

echo "Installation complete! 🎉"
echo "You can now find 'YT Audio Downloader' in your application launcher menu."
