#!/usr/bin/env python3

import os
import sys
import subprocess
import urllib.request
from pathlib import Path

custom_path = sys.argv[1] if len(sys.argv) > 1 else ""

hour = int(__import__("datetime").datetime.now().hour)
if 4 <= hour < 12:
    greeting = "Good morning"
elif 12 <= hour < 18:
    greeting = "Good afternoon"
else:
    greeting = "Good evening"

print(f"🎩 {greeting}. Pray allow me to assist you with this endeavour.")
print("📦 I shall now procure the curl installer and execute it on your behalf...")

def download_file(url, dest):
    try:
        urllib.request.urlretrieve(url, dest)
    except Exception as e:
        raise Exception(f"Failed to download {url}: {e}")

def main():
    try:
        script_path = Path("/tmp/litellm-router-curl-setup.sh")
        
        print(" Acquiring the curl installer...")
        download_file(
            "https://raw.githubusercontent.com/vvmspace/litellm-router/refs/heads/main/curl-setup.sh",
            script_path
        )
        
        script_path.chmod(0o755)
        
        print("� I shall now proceed to execute the installer...")
        if custom_path:
            subprocess.run(f"sh {script_path} {custom_path}", shell=True, check=True)
        else:
            subprocess.run(f"sh {script_path}", shell=True, check=True)
        
        script_path.unlink()
        
    except Exception as e:
        print(f"❌ An unfortunate error has occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
