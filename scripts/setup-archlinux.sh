#!/bin/bash
set -e -u

PACKAGES=""
PACKAGES+=" apache-ant" # Used by apksigner.
PACKAGES+=" asciidoc"
PACKAGES+=" automake"
PACKAGES+=" bison"
PACKAGES+=" clang" # Used by golang, useful to have same compiler building.
PACKAGES+=" curl" # Used for fetching sources.
PACKAGES+=" ed" # Used by bc
PACKAGES+=" flex"
PACKAGES+=" gettext" # Provides 'msgfmt' which the apt build uses.
PACKAGES+=" git" # Used by the neovim build.
PACKAGES+=" help2man"
PACKAGES+=" intltool" # Used by qalc build.
PACKAGES+=" glib2" # Provides 'glib-genmarshal' which the glib build uses.
PACKAGES+=" libtool"
#PACKAGES+=" ncurses5-compat-libs" # Used by mariadb for host build part. - only available in aur
PACKAGES+=" lzip"
PACKAGES+=" python"
PACKAGES+=" tar"
PACKAGES+=" unzip"
PACKAGES+=" m4"
PACKAGES+=" jre8-openjdk-headless" # Used for android-sdk.
PACKAGES+=" pkg-config"
PACKAGES+=" python-docutils" # For rst2man, used by mpv.
PACKAGES+=" python-setuptools" # Needed by at least asciinema.
PACKAGES+=" scons"
PACKAGES+=" texinfo"
PACKAGES+=" xmlto"
#PACKAGES+=" xutils-dev" # Provides 'makedepend' which the openssl build uses.
PACKAGES+=" expat" # Needed by ghostscript
PACKAGES+=" libjpeg-turbo" # Needed by ghostscript
PACKAGES+=" patch"

sudo pacman -Syq --noconfirm $PACKAGES

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R `whoami` /data

echo "Please also install ncurses5-compat-libs and makedepend packages from the AUR before continuing"
