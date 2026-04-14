#!/bin/bash
# Contents/MacOS/WhisperTranscriber
# Launches Terminal to run transcribe.sh with cwd set to the folder
# containing the .app bundle.

APP_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
PARENT="$(dirname "$APP_DIR")"
SCRIPT="$APP_DIR/Contents/Resources/transcribe.sh"

osascript <<EOF
tell application "Terminal"
    activate
    do script "cd " & quoted form of "$PARENT" & " && " & quoted form of "$SCRIPT"
end tell
EOF
