FROM ubuntu:resolute

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk wget unzip git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=gradle-cache /root/.gradle /root/.gradle

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

COPY --from=android-cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools

RUN yes | sdkmanager --licenses && \
    sdkmanager \
        "platform-tools" \
        "platforms;android-34" \
        "platforms;android-36" \
        "build-tools;34.0.0" \
        "build-tools;35.0.0" \
        "ndk;27.0.12077973"

# 设置工作目录
WORKDIR /workspace

# 默认启动 bash
CMD ["bash"]
