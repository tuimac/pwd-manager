FROM ubuntu:latest

#
# System environment variable
#
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

#
# Environment variable for this container
#
ENV WORK_DIR=/root
ENV PORT=80
ENV FLUTTER_DIR=/opt/flutter
ENV GITHUB_REPO=pwd-manager
ENV GITHUB_USER=tuimac
ENV GITHUB_EMAIL=tuimac.devadm01@gmail.com
ENV APT_REPO_HOSTNAME=ap-northeast-3.ec2.archive.ubuntu.com
ENV PJT_DIR="${WORK_DIR}/${GITHUB_REPO}/app"
ENV ANDROID_HOME=/opt/android
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
ENV PATH="${PATH}:${FLUTTER_DIR}/bin:${ANDROID_HOME}:${ANDROID_HOME}/cmdline-tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator"

#
# Tools version for Android
#
# https://developer.android.com/studio
ENV ANDROID_SDK_CMD_TOOL_VERSION=9477386
# https://apilevels.com
ENV ANDROID_SDK_API_LEVEL=android-34
# https://developer.android.com/studio/releases/build-tools
ENV ANDROID_BUILD_TOOLS_VERSION=34.0.0

EXPOSE ${PORT}

WORKDIR ${WORK_DIR}

SHELL ["/bin/bash", "-c"]

RUN sed -i 's/archive.ubuntu.com/'$APT_REPO_HOSTNAME'/g' /etc/apt/sources.list && \
    apt update && \
    apt upgrade -y && \
    apt install -y tzdata git unzip tree curl jq clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev openjdk-17-jdk openjdk-17-jre fonts-liberation libu2f-udev libvulkan1 wget xdg-utils && \
    apt --fix-broken install && \
    apt clean && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb && \
    rm -rf google-chrome-stable_current_amd64.deb && \
    curl https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_CMD_TOOL_VERSION}_latest.zip -o cmdline-tools.zip && \
    unzip cmdline-tools.zip -d ${ANDROID_HOME} && \
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 ${FLUTTER_DIR} && \
    flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web && \
    flutter config --android-sdk ${ANDROID_SDK_ROOT} && \
    flutter precache && \
    git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git && \
    cd ${PJT_DIR} && \
    git config --global user.email ${GITHUB_EMAIL} && \
    git config --global user.name ${GITHUB_USER} && \
    flutter pub get && \
    yes | sdkmanager --licenses --sdk_root=${ANDROID_HOME} && \
    touch ${HOME}/.android/repositories.cfg && \
    sdkmanager platform-tools --sdk_root=${ANDROID_HOME} && \
    sdkmanager emulator --sdk_root=${ANDROID_HOME} && \
    sdkmanager "platforms;${ANDROID_SDK_API_LEVEL}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" --sdk_root=${ANDROID_HOME} && \
    sdkmanager --install "cmdline-tools;latest" --sdk_root=${ANDROID_HOME} && \
    yes | flutter doctor --android-licenses && \
    flutter doctor

#
# Timezone
#
ENV TZ=Asia/Tokyo