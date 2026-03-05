# YouTube Audio Downloader

A purely vibe-coded Flutter desktop application that serves as a GUI wrapper around `yt-dlp` and `ffmpeg` to download and convert YouTube videos into audio formats (MP3, WAV, FLAC, M4A, AAC) with selectable quality. 

## Prerequisites

This application relies on the following command-line tools to be installed on your system:
- `yt-dlp` (for downloading from YouTube)
- `ffmpeg` (for audio extraction and conversion)

Make sure they are installed. On Arch Linux / EndeavourOS, you can install them via:
```bash
sudo pacman -S yt-dlp ffmpeg
```

## Installation

You can install this application directly from the Arch User Repository (AUR) using `yay`:

```bash
yay -S yt-audio-dl-bin
```

This will install the application system-wide and add a shortcut to your desktop environment's application launcher.

## Usage

1. Open **YT Audio Downloader** from your application menu.
2. Paste a valid YouTube URL.
3. Select your desired output **Audio Format** and **Audio Quality**.
4. Set the **Output Directory** (defaults to `~/Music`).
5. Click **Download**.

The application will display the title of the video being downloaded and a progress bar indicating the download status. 
