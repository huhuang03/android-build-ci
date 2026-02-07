set dotenv-load := true
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

IMG_NAME := env_var("IMG_NAME")

build:
    docker build -t gradle-cache docker-module/gradle-cache
    docker build -t android-cmdline-tools docker-module/android-cmdline-tools
    docker build -t {{IMG_NAME}}:latest .

publish: build
    docker push {{IMG_NAME}}:latest


bash:
    docker run --rm -it {{IMG_NAME}}
