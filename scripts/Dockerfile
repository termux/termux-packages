# Build with:
# 	docker build -t termux/package-builder .
# Push to docker hub with:
# 	docker push termux/package-builder
# This is done after changing this file or any of the
# scripts/setup-{ubuntu,android-sdk}.sh setup scripts.
FROM ubuntu:16.10

# Fix locale to avoid warnings:
ENV LANG C.UTF-8

# We expect this to be mounted with '-v $PWD:/root/termux-packages':
WORKDIR /root/termux-packages

# Needed for setup:
ADD ./setup-ubuntu.sh /tmp/setup-ubuntu.sh
ADD ./setup-android-sdk.sh /tmp/setup-android-sdk.sh

# Allow configure to be run as root:
ENV FORCE_UNSAFE_CONFIGURE 1

# Setup needed packages and the Android SDK and NDK:
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq sudo && \
    /tmp/setup-ubuntu.sh && \
    apt-get clean && \
    /tmp/setup-android-sdk.sh && \
    # Removed unused parts to make a smaller Docker image:
    cd /root/lib/android-ndk/ && \
    rm -Rf toolchains/mips* && \
    rm -Rf sources/cxx-stl/gabi++ sources/cxx-stl/llvm-libc++* sources/cxx-stl/system/ sources/cxx-stl/stlport && \
    cd platforms && ls | grep -v android-21 | xargs rm -Rf && \
    cd /root/lib/android-sdk/tools && rm -Rf emulator* lib* proguard templates

