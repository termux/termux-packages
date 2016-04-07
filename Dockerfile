FROM ubuntu:15.10
MAINTAINER Alex Cornejo <acornejo@gmail.com>

# to prevent dialog warnings
ENV DEBIAN_FRONTEND noninteractive
# to fix locale to avoid warnings
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get update && apt-get install -y \
        sudo \
        git \
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
        libtool-bin \
        lua-lpeg \
        luarocks \
        lzip \
        m4 \
        pkg-config \
        scons \
        subversion \
        texinfo \
        xmlto \
# Provides u'makedepend' which the openssl build uses
        xutils-dev \
# Needed for android-sdk
        openjdk-7-jdk


RUN cd /tmp && \
    curl -O http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz && \
    tar xzvf /tmp/android-sdk_r24.3.4-linux.tgz && \
    curl -o ndk.zip http://dl.google.com/android/repository/android-ndk-r11-linux-x86_64.zip && \
    unzip ndk.zip && \
    mkdir /root/lib && \
    mv /tmp/android-sdk-linux /root/lib/android-sdk && \
    mv /tmp/android-ndk-r11 /root/lib/android-ndk && \
    rm -fr /tmp/*

RUN mkdir -p /data/data/com.termux/files/usr && mkdir -p /root/termux-packages && \
# Install neovim dependencies
    luarocks install lpeg && \
    luarocks install lua-MessagePack && \
    luarocks install luabitop

ADD scripts /root/termux-packages/scripts
ADD *.sh /root/termux-packages/
ADD *.spec /root/termux-packages/
ADD packages /root/termux-packages/packages
ADD ndk_patches /root/termux-packages/ndk_patches
