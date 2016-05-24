FROM ubuntu:16.04

# Fix locale to avoid warnings:
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

# Add this folder to the container and set as working directory:
ADD . /root/termux-packages
WORKDIR /root/termux-packages

# Allow configure to be run as root:
ENV FORCE_UNSAFE_CONFIGURE 1

RUN apt-get update && \
    apt-get install -y sudo && \
    USER=root /root/termux-packages/scripts/ubuntu-setup.sh && \
    # Setup Android SDK and NDK:
    mkdir -p /root/lib && \
    cd /root/lib && \
    curl -o sdk.tgz http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz && \
    tar xzvf sdk.tgz && \
    mv android-sdk-linux android-sdk && \
    curl -o ndk.zip http://dl.google.com/android/repository/android-ndk-r11-linux-x86_64.zip && \
    unzip ndk.zip && \
    mv android-ndk-r11 android-ndk && \
    /root/termux-packages/scripts/install-sdk.sh
