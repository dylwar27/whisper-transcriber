#!/bin/bash
# ─────────────────────────────────────────────────────────
#  Whisper Transcriber (app bundle worker)
#  Invoked by the .app's launcher; cwd is already set to
#  the folder containing the .app.
#  Supports: M4A, MP3, WAV, OGG, FLAC, AAC, WMA,
#            MP4, MOV, MKV, WEBM, AVI (audio track)
# ─────────────────────────────────────────────────────────

PYTHON="/Library/Developer/CommandLineTools/usr/bin/python3"

# Check dependencies
if ! command -v ffmpeg &>/dev/null; then
  echo "Error: ffmpeg not found. Install with: brew install ffmpeg"
  echo "Press any key to exit..."
  read -n1
  exit 1
fi

if ! "$PYTHON" -c "import whisper" 2>/dev/null; then
  echo "Error: Whisper not installed. Installing now..."
  "$PYTHON" -m pip install openai-whisper
fi

"$PYTHON" -c '
import sys, warnings
from pathlib import Path

warnings.filterwarnings("ignore")

MEDIA_EXT = {
    # Audio
    ".m4a", ".mp3", ".wav", ".ogg", ".flac", ".aac", ".wma",
    # Video (extracts audio track automatically via ffmpeg)
    ".mp4", ".mov", ".mkv", ".webm", ".avi", ".m4v", ".mpg", ".mpeg",
}
folder = Path(".")

media_files = sorted({f for f in folder.iterdir() if f.suffix.lower() in MEDIA_EXT})
to_do = [f for f in media_files if not f.with_suffix(".txt").exists()]

if not media_files:
    print("No audio/video files found in this folder.")
    sys.exit(0)

print(f"\nFound {len(media_files)} media files, {len(media_files)-len(to_do)} already transcribed.")

if not to_do:
    print("All done!")
    sys.exit(0)

print(f"Transcribing {len(to_do)} files...\n")

import whisper
model = whisper.load_model("base")
ok = 0

for i, f in enumerate(to_do, 1):
    print(f"[{i}/{len(to_do)}] {f.name}...", end=" ", flush=True)
    try:
        result = model.transcribe(str(f))
        lines = []
        for seg in result["segments"]:
            start = seg["start"]
            h, m, s = int(start // 3600), int((start % 3600) // 60), start % 60
            timestamp = f"[{h:02d}:{m:02d}:{s:05.2f}]"
            lines.append(f"{timestamp} {seg[\"text\"].strip()}")
        f.with_suffix(".txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
        print("done")
        ok += 1
    except Exception as e:
        print(f"FAILED ({e})")

print(f"\nFinished: {ok} transcribed, {len(to_do)-ok} failed.")
'

echo ""
echo "Press any key to close..."
read -n1
