FROM ubuntu:15.04
MAINTAINER Alex Cornejo <acornejo@gmail.com>

# to prevent dialog warnings
ENV DEBIAN_FRONTEND noninteractive
# to fix locale to avoid warnings
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get update && apt-get install -y \
        sudo \
        asciidoc \
        automake \
        bison \
        flex \
        cmake \
# Used for fetching sources
        curl \
# Provides 'msgfmt' which the apt build uses
        gettext \
        help2man \
        libacl1-dev \
# Needed by luajit host part
        libc6-dev-i386 \
# Needed by apt build
        libcurl4-openssl-dev \
# Provides 'gkd-pixbuf-query-loaders' which the librsvg build uses
        libgdk-pixbuf2.0-dev \
# Provides 'glib-genmarshal' which the glib build uses
        libglib2.0-dev \
        libncurses5-dev \
        libssl-dev \
        libtool \
        lzip \
        m4 \
        pkg-config \
        scons \
        texinfo \
        xmlto \
# Provides u'makedepend' which the openssl build uses
        xutils-dev \
# Needed for android-sdk
        openjdk-7-jdk


RUN cd /tmp && \
    curl -O http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz && \
    curl -O http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin && \
    tar xzvf /tmp/android-sdk_r24.3.4-linux.tgz && \
    chmod 755 /tmp/android-ndk* && /tmp/android-ndk-r10e-linux-x86_64.bin && \
    mkdir /root/lib && \
    mv /tmp/android-sdk-linux /root/lib/android-sdk && \
    mv /tmp/android-ndk-r10e  /root/lib/android-ndk && \
    rm -fr /tmp/* \
# This link is needed for building git package
    ln -s / /system

RUN mkdir -p /data/data/com.termux/files/usr && mkdir -p /root/termux-packages
ADD *.py /root/termux-packages/
ADD *.sh /root/termux-packages/
ADD *.spec /root/termux-packages/
ADD packages /root/termux-packages/packages
ADD ndk_patches /root/termux-packages/ndk_patches
