#!/bin/bash
set -e -u -o pipefail

PACKAGES=""
PACKAGES+=" ant" # Used by apksigner.
PACKAGES+=" asciidoc"
PACKAGES+=" automake"
PACKAGES+=" bison"
PACKAGES+=" clang" # Used by golang, useful to have same compiler building.
PACKAGES+=" curl" # Used for fetching sources.
PACKAGES+=" flex"
PACKAGES+=" gettext" # Provides 'msgfmt' which the apt build uses.
PACKAGES+=" help2man"
PACKAGES+=" intltool" # Used by qalc build.
PACKAGES+=" libglib2.0-dev" # Provides 'glib-genmarshal' which the glib build uses.
PACKAGES+=" libtool-bin"
PACKAGES+=" libncurses5-dev" # Used by mariadb for host build part.
PACKAGES+=" lzip"
PACKAGES+=" python-setuptools"
PACKAGES+=" python3.6"
PACKAGES+=" python-pip"
PACKAGES+=" python-dev"
PACKAGES+=" build-essential"
PACKAGES+=" tar"
PACKAGES+=" unzip"
PACKAGES+=" m4"
PACKAGES+=" openjdk-8-jdk-headless" # Used for android-sdk.
PACKAGES+=" pkg-config"
PACKAGES+=" python3-docutils" # For rst2man, used by mpv.
PACKAGES+=" python3-setuptools" # Needed by at least asciinema.
PACKAGES+=" scons"
PACKAGES+=" texinfo"
PACKAGES+=" xmlto"
PACKAGES+=" xutils-dev" # Provides 'makedepend' which the openssl build uses.

DEBIAN_FRONTEND=npninteractive sudo apt-get install -y git aria2
if ! [[ -f /usr/bin/apt-fast ]];
then git clone https://github.com/ilikenwf/apt-fast /tmp/apt-fast
sudo cp /tmp/apt-fast/apt-fast /usr/bin
sudo chmod +x /usr/bin/apt-fast
sudo cp /tmp/apt-fast/apt-fast.conf /etc
fi

DEBIAN_FRONTEND=noninteractive sudo apt-fast install -y $PACKAGES

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R `whoami` /data
