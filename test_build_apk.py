import os
import subprocess
from pathlib import Path
from dotenv import load_dotenv
load_dotenv()

IMG_NAME = os.getenv("IMG_NAME")

project_dir = Path.cwd() / "test-android-build-app"
output_dir = Path.cwd() / "apk-output"
output_dir.mkdir(exist_ok=True)

cmd = [
    "docker", "run", "--rm",
    "-v", f"{project_dir}:/workspace",
    "-v", f"{output_dir}:/workspace/app/build/outputs/apk",
    IMG_NAME,
    "bash", "-c", "cd /workspace && ./gradlew assembleDebug"
]

subprocess.run(cmd, check=True)
print(f"Build finished. APK in {output_dir}")
