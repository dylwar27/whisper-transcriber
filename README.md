# Whisper Transcriber

A tiny, portable macOS tool for batch-transcribing audio and video files using [OpenAI Whisper](https://github.com/openai/whisper). Drop `transcribe.command` into any folder, double-click, and every audio/video file in that folder gets transcribed to a matching `.txt` file.

## Features

- **Drop-in & double-click** — no arguments, no config. The script runs against its own folder.
- **Resumable** — skips any file that already has a `.txt` transcript, so you can cancel and re-run safely.
- **Timestamped output** — each line is prefixed with `[HH:MM:SS.ss]` so you can navigate long recordings.
- **Handles audio and video** — extracts the audio track automatically for video files via ffmpeg.
- **Self-healing** — auto-installs the `openai-whisper` Python package if missing.

## Supported formats

| Type  | Extensions                                      |
| ----- | ----------------------------------------------- |
| Audio | `.m4a` `.mp3` `.wav` `.ogg` `.flac` `.aac` `.wma` |
| Video | `.mp4` `.mov` `.mkv` `.webm` `.avi` `.m4v` `.mpg` `.mpeg` |

## Requirements

- macOS with the system Python 3 at `/Library/Developer/CommandLineTools/usr/bin/python3` (installed by `xcode-select --install`)
- [Homebrew](https://brew.sh)
- `ffmpeg` — install with `brew install ffmpeg`

The Whisper package itself is auto-installed on first run.

## Usage

1. Copy `transcribe.command` into any folder with audio or video files.
2. Make it executable (first time only):
   ```bash
   chmod +x transcribe.command
   ```
3. Double-click it in Finder, or from Terminal:
   ```bash
   ./transcribe.command
   ```
4. Each media file gets a `filename.txt` written alongside it.

## Output format

```
[00:00:00.00] Hey, this is a quick voice memo.
[00:00:03.42] I'm thinking about the project timeline.
[00:00:08.91] Remind me to follow up with the team next week.
```

## Model

Uses Whisper's `base` model by default — a good balance of speed and accuracy for most voice recordings. To use a different model, edit this line in `transcribe.command`:

```python
model = whisper.load_model("base")
```

Options: `tiny`, `base`, `small`, `medium`, `large`. Larger = more accurate but slower and uses more RAM.

## Notes

- The first run downloads the Whisper model (~140 MB for `base`) to `~/.cache/whisper/`.
- Runs on CPU — you'll see a harmless "FP16 not supported on CPU" warning (suppressed in this script).
- Transcription speed depends on audio length and your Mac's specs. Roughly real-time or faster for short clips on the `base` model.

## License

MIT
