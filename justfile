set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

build:
    docker build -t android-build-slim .
