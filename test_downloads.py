import subprocess
import os
import sys

# Test settings
URL = "https://youtu.be/xnP7qKxwzjg?si=zg8QUCbdMtIAD-wz"
FORMATS = ['mp3', 'wav', 'flac', 'm4a', 'aac']
QUALITIES = ['320K', '256K', '192K', '128K', '64K', '0']
OUTPUT_DIR = "test_downloads"

os.makedirs(OUTPUT_DIR, exist_ok=True)

def run_test(audio_format, quality):
    # '0' in the UI maps to '0' here which means best VBR for yt-dlp
    output_template = f"{OUTPUT_DIR}/%(title)s_{audio_format}_{quality}.%(ext)s"
    
    cmd = [
        "yt-dlp",
        "-x",
        "--audio-format", audio_format,
        "--audio-quality", quality,
        "-o", output_template,
        URL
    ]
    
    print(f"Testing Format: {audio_format}, Quality: {quality}")
    print(f"Command: {' '.join(cmd)}")
    
    try:
        result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if result.returncode == 0:
            print(f"✅ Success: {audio_format} - {quality}")
        else:
            print(f"❌ Failed: {audio_format} - {quality}")
            print(result.stderr)
            return False
    except Exception as e:
        print(f"❌ Exception: {e}")
        return False
        
    return True

def main():
    print("Starting tests...")
    success = True
    for fmt in FORMATS:
        for quality in QUALITIES:
            # Some formats like wav and flac are lossless and ignore quality settings,
            # but we still want to test to ensure yt-dlp handles it without error
            if not run_test(fmt, quality):
                success = False
                break
        if not success:
            break

    if success:
        print("\nAll tests passed successfully! 🎉")
        sys.exit(0)
    else:
        print("\nSome tests failed. 😢")
        sys.exit(1)

if __name__ == "__main__":
    main()
