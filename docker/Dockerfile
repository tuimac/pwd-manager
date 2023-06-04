FROM ubuntu:latest

ENV PJT_NAME=flutter-server
ENV FLUTTER_DIR=/opt/flutter
ENV WORK_DIR=/root
ENV PATH="${PATH}:${FLUTTER_DIR}/bin"

WORKDIR $WORK_DIR

EXPOSE 8000

RUN apt update && \
    apt upgrade -y && \
    apt install -y git unzip tree curl jq clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev default-jdk && \
    curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb && \
    rm -f dpkg -i google-chrome-stable_current_amd64.deb && \
    echo "Asia/Tokyo" >  /etc/timezone && \
    mkdir -p /etc/vim/backup && \
    mkdir -p /etc/vim/undo && \
    curl -L https://raw.githubusercontent.com/tuimac/tools/master/vim/vimrc -o /etc/vim/vimrc && \
    curl -L https://raw.githubusercontent.com/tuimac/tools/master/linux/bashrc/.bashrc_node_docker -o /root/.bashrc && \
    curl -L https://raw.githubusercontent.com/tuimac/tools/master/git/setup.sh -o setup.sh && \
    chmod +x setup.sh && \
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 $FLUTTER_DIR
