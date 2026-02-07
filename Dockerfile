FROM ubuntu:resolute

ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    wget \
    unzip \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 创建 Android SDK 目录
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools

# 下载并安装 Android SDK Command-line Tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip \
    && unzip /tmp/cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools \
    && mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest \
    && rm /tmp/cmdline-tools.zip

# 安装 Android SDK 平台和构建工具
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# 可选：安装 Gradle（命令行构建 Android 项目需要）
ENV GRADLE_VERSION=8.3
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O /tmp/gradle.zip \
    && unzip /tmp/gradle.zip -d /opt/gradle \
    && rm /tmp/gradle.zip
ENV PATH=/opt/gradle/gradle-${GRADLE_VERSION}/bin:$PATH


ENV GRADLE_VERSIONS="7.6 8.0 8.3 8.13"
RUN mkdir -p /root/.gradle/wrapper/dists && \
    for v in $GRADLE_VERSIONS; do \
      wget https://services.gradle.org/distributions/gradle-${v}-bin.zip -O /tmp/gradle-wrapper-${v}.zip && \
      unzip /tmp/gradle-wrapper-${v}.zip -d /root/.gradle/wrapper/dists/gradle-${v}-bin && \
      rm /tmp/gradle-wrapper-${v}.zip; \
    done

# 设置工作目录
WORKDIR /workspace

# 默认命令：进入 bash
CMD ["bash"]
