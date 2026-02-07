FROM ubuntu:resolute AS gradle-cache

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk curl unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV GRADLE_USER_HOME=/root/.gradle
WORKDIR /tmp

# 1️⃣ 先下载一个“引导用”的 Gradle（任意较新版本即可）
ENV BOOTSTRAP_GRADLE_VERSION=8.3
RUN curl -sLo gradle.zip https://services.gradle.org/distributions/gradle-${BOOTSTRAP_GRADLE_VERSION}-bin.zip \
    && unzip -q gradle.zip -d /opt \
    && rm gradle.zip

ENV PATH=/opt/gradle-${BOOTSTRAP_GRADLE_VERSION}/bin:$PATH

# 2️⃣ 创建一个临时项目
RUN mkdir /tmp/gradle-project && cd /tmp/gradle-project && gradle init --type basic --dsl groovy --project-name temp --test-framework none --no-daemon

WORKDIR /tmp/gradle-project

# 3️⃣ 你要预缓存的 wrapper 版本
ENV GRADLE_VERSIONS="7.6 8.0 8.3 8.13"

# 4️⃣ 循环生成 wrapper 并触发下载
RUN for v in $GRADLE_VERSIONS; do \
      gradle wrapper --gradle-version $v --no-daemon; \
      ./gradlew --version || true; \
    done
