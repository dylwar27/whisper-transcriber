#!/bin/bash
# Builds WhisperTranscriber.app from app-src/.
# Output is a double-clickable macOS app bundle that preserves its
# executable bit across Dropbox, zip, AirDrop, etc.
set -e
cd "$(dirname "$0")"

APP="WhisperTranscriber.app"
rm -rf "$APP"

mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp app-src/Info.plist        "$APP/Contents/Info.plist"
cp app-src/launcher.sh       "$APP/Contents/MacOS/WhisperTranscriber"
cp app-src/transcribe.sh     "$APP/Contents/Resources/transcribe.sh"
chmod +x "$APP/Contents/MacOS/WhisperTranscriber" \
         "$APP/Contents/Resources/transcribe.sh"

echo "Built $APP"
