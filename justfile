set dotenv-load := true
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

IMG_NAME := env_var("IMG_NAME")

build:
    docker build -t {{IMG_NAME}} .


bash:
    docker run --rm -it {{IMG_NAME}}
