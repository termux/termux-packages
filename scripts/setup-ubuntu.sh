#!/usr/bin/env bash
set -e -u

PACKAGES=""

# For en_US.UTF-8 locale.
PACKAGES+=" locales"

# To provide /usr/bin/python as symlink to /usr/bin/python3
PACKAGES+=" python-is-python3"

# Used by build-package.sh and CI/CD scripts.
PACKAGES+=" curl"
PACKAGES+=" gnupg"

# Used for fetching package sources from Git repositories.
PACKAGES+=" git"

# Used for extracting package sources.
PACKAGES+=" lzip"
PACKAGES+=" tar"
PACKAGES+=" unzip"
PACKAGES+=" lrzip"
PACKAGES+=" lzop"
PACKAGES+=" lz4"
PACKAGES+=" zstd"

# Used by common build systems.
PACKAGES+=" autoconf"
PACKAGES+=" autogen"
PACKAGES+=" automake"
PACKAGES+=" autopoint"
PACKAGES+=" bison"
PACKAGES+=" flex"
PACKAGES+=" g++"
PACKAGES+=" g++-multilib"
PACKAGES+=" gawk"
PACKAGES+=" gettext"
PACKAGES+=" gperf"
PACKAGES+=" intltool"
PACKAGES+=" libglib2.0-dev"
PACKAGES+=" libltdl-dev"
PACKAGES+=" libtool-bin"
PACKAGES+=" m4"
PACKAGES+=" pkg-config"
PACKAGES+=" scons"

# Used to generate package documentation.
PACKAGES+=" asciidoc"
PACKAGES+=" asciidoctor"
PACKAGES+=" groff"
PACKAGES+=" help2man"
PACKAGES+=" pandoc"
PACKAGES+=" python3-docutils"
PACKAGES+=" python3-recommonmark"
PACKAGES+=" python3-sphinx"
PACKAGES+=" python3-sphinx-rtd-theme"
PACKAGES+=" python3-sphinxcontrib.qthelp"
PACKAGES+=" scdoc"
PACKAGES+=" texinfo"
PACKAGES+=" xmlto"
PACKAGES+=" xmltoman"

# Needed by python modules (e.g. asciinema) and some build systems.
PACKAGES+=" python3.9"
PACKAGES+=" python3.10"
PACKAGES+=" python3.11"
PACKAGES+=" python3-pip"
PACKAGES+=" python3-setuptools"
PACKAGES+=" python-wheel-common"
PACKAGES+=" python3.10-venv"
PACKAGES+=" python3.11-venv"

# Needed by package bc.
PACKAGES+=" ed"

# Needed by gnunet.
PACKAGES+=" recutils"

# Provides utility hexdump which is needed by package bitcoin.
PACKAGES+=" bsdmainutils"

# Needed by package seafile-client.
PACKAGES+=" valac"

# Needed by package libgcrypt.
PACKAGES+=" fig2dev"

# Needed by package gimp.
PACKAGES+=" gegl"

# Needed by package libidn2.
PACKAGES+=" gengetopt"

# Needed by package proxmark3-git.
PACKAGES+=" swig"

# Needed by package dbus-glib.
PACKAGES+=" libdbus-1-dev"

# Needed by package below.
PACKAGES+=" libelf-dev"

# Needed by package ghostscript.
PACKAGES+=" libexpat1-dev"
PACKAGES+=" libjpeg-dev"

# Needed by package gimp3.
PACKAGES+=" librsvg2-dev"

# Needed by package news-flash-gtk.
PACKAGES+=" libsqlite3-dev"

# Needed by package fennel.
PACKAGES+=" lua5.3"

# Needed by package vlc.
PACKAGES+=" lua5.2"

# Needed by package luarocks.
PACKAGES+=" lua5.1"

# Used bt host build of package mariadb.
PACKAGES+=" libncurses5-dev"

# Needed to build neovim >= 8.0.0
PACKAGES+=" lua-lpeg"
PACKAGES+=" lua-mpack"

# Needed by host build of package ruby.
PACKAGES+=" libyaml-dev"

# Needed by package mkvtoolnix.
PACKAGES+=" ruby"

# Needed by host build of package nodejs.
PACKAGES+=" libc-ares-dev"
PACKAGES+=" libicu-dev"

# Needed by php.
PACKAGES+=" re2c"

# Needed by composer.
PACKAGES+=" php"
PACKAGES+=" php-xml"
PACKAGES+=" composer"

# Needed by package rust.
PACKAGES+=" libssl-dev" # Needed to build Rust
PACKAGES+=" llvm-13-dev"
PACKAGES+=" llvm-13-tools"
PACKAGES+=" clang-13"

# Needed for package smalltalk.
PACKAGES+=" libsigsegv-dev"
PACKAGES+=" zip"

# Needed for package sqlcipher.
PACKAGES+=" tcl"

# Needed by package swi-prolog.
PACKAGES+=" openssl"
PACKAGES+=" zlib1g-dev"
PACKAGES+=" libssl-dev:i386"
PACKAGES+=" zlib1g-dev:i386"

# For swift.
PACKAGES+=" lld"

# Needed by wrk.
PACKAGES+=" luajit"

# Needed by libduktape
PACKAGES+=" bc"

# Java.
PACKAGES+=" openjdk-8-jdk openjdk-18-jdk"

# needed by ovmf
PACKAGES+=" libarchive-tools"

# Needed by cavif-rs
PACKAGES+=" nasm"

# Needed by dgsh
PACKAGES+=" rsync"

# Needed by megacmd
PACKAGES+=" wget"

# Needed by codeblocks
PACKAGES+=" libwxgtk3.0-gtk3-dev"
PACKAGES+=" libgtk-3-dev"

# Needed by packages in unstable repository.
PACKAGES+=" comerr-dev"
PACKAGES+=" docbook-to-man"
PACKAGES+=" docbook-utils"
PACKAGES+=" erlang-nox"
PACKAGES+=" heimdal-multidev"
PACKAGES+=" libconfig-dev"
PACKAGES+=" libevent-dev"
PACKAGES+=" libgc-dev"
PACKAGES+=" libgmp-dev"
PACKAGES+=" libjansson-dev"
PACKAGES+=" libparse-yapp-perl"
PACKAGES+=" libreadline-dev"
PACKAGES+=" libunistring-dev"

# Needed by packages in X11 repository.
PACKAGES+=" alex"
PACKAGES+=" docbook-xsl-ns"
PACKAGES+=" gnome-common"
PACKAGES+=" gobject-introspection"
PACKAGES+=" gtk-3-examples"
PACKAGES+=" gtk-doc-tools"
PACKAGES+=" happy"
PACKAGES+=" itstool"
PACKAGES+=" libdbus-glib-1-dev-bin"
PACKAGES+=" libgdk-pixbuf2.0-dev"
PACKAGES+=" libwayland-dev"
PACKAGES+=" python-setuptools"
PACKAGES+=" python3-xcbgen"
PACKAGES+=" sassc"
PACKAGES+=" texlive-extra-utils"
PACKAGES+=" wayland-scanner++"
PACKAGES+=" xfce4-dev-tools"
PACKAGES+=" xfonts-utils"
PACKAGES+=" xutils-dev"
PACKAGES+=" desktop-file-utils"

# Needed by packages in science repository
PACKAGES+=" protobuf-c-compiler"
PACKAGES+=" sqlite3"

# Needed by packages in game repository
PACKAGES+=" cvs"
PACKAGES+=" python3-yaml"

# Needed by gobject-introspection (termux_setup_gir).
PACKAGES+=" bash-static"

# Needed by apt.
PACKAGES+=" triehash"

# Needed by aspell dictionaries.
PACKAGES+=" aspell"

# Needed by package kphp.
PACKAGES+=" python3-jsonschema"

# Needed by package lilypond.
PACKAGES+=" fontforge-nox"
PACKAGES+=" guile-3.0"
PACKAGES+=" python3-fontforge"
PACKAGES+=" texlive-metapost"

# Needed by package motif.
PACKAGES+=" libfl-dev"
PACKAGES+=" libxft-dev"
PACKAGES+=" libxt-dev"
PACKAGES+=" xbitmaps"

# Needed by proxmark3/proxmark3-git
PACKAGES+=" gcc-arm-none-eabi"

# Needed by pypy
PACKAGES+=" qemu-user-static"

# Required by cava
PACKAGES+=" xxd"

# Required by samba
PACKAGES+=" libjson-perl"

# Required for parsing repo.json
PACKAGES+=" jq"

# Required by txikijs's hostbuild step
PACKAGES+=" libcurl4-openssl-dev"

# Required by openjdk-17
PACKAGES+=" openjdk-17-jre openjdk-17-jdk"

# Required by qt5-qtwebengine
PACKAGES+=" libnss3 libnss3:i386 libnss3-dev"
PACKAGES+=" libwebp7 libwebp7:i386 libwebp-dev"
PACKAGES+=" libwebpdemux2 libwebpdemux2:i386"
PACKAGES+=" libwebpmux3 libwebpmux3:i386"

# Do not require sudo if already running as root.
if [ "$(id -u)" = "0" ]; then
	SUDO=""
else
	SUDO="sudo"
fi

# Allow 32-bit packages.
$SUDO dpkg --add-architecture i386
# Add ppa repo to be able to get openjdk-17 on ubuntu 22.04
$SUDO cp $(dirname "$(realpath "$0")")/openjdk-r-ppa.gpg /etc/apt/trusted.gpg.d/
echo "deb https://ppa.launchpadcontent.net/openjdk-r/ppa/ubuntu/ jammy main" | $SUDO tee /etc/apt/sources.list.d/openjdk-r-ubuntu-ppa-jammy.list > /dev/null
$SUDO apt-get -yq update

$SUDO env DEBIAN_FRONTEND=noninteractive \
	apt-get install -yq --no-install-recommends $PACKAGES

# Pip for python2.
curl -L --output /tmp/py2-get-pip.py https://bootstrap.pypa.io/pip/2.7/get-pip.py
$SUDO python2 /tmp/py2-get-pip.py
rm -f /tmp/py2-get-pip.py

$SUDO locale-gen --purge en_US.UTF-8
echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' | $SUDO tee -a /etc/default/locale

. $(dirname "$(realpath "$0")")/properties.sh
$SUDO mkdir -p $TERMUX_PREFIX
$SUDO chown -R $(whoami) /data
