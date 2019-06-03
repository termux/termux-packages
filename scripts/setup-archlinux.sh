#!/bin/bash
set -e -u

PACKAGES=""
PACKAGES+=" patch"
PACKAGES+=" asciidoc"
PACKAGES+=" asciidoctor" # Used by weechat for man pages.
PACKAGES+=" automake"
PACKAGES+=" bison"
PACKAGES+=" clang" # Used by golang, useful to have same compiler building.
PACKAGES+=" curl" # Used for fetching sources.
PACKAGES+=" ed" # Used by bc.
PACKAGES+=" flex"
PACKAGES+=" gcc" # Host C/C++ compiler.
PACKAGES+=" gettext" # Provides 'msgfmt'.
PACKAGES+=" git" # Used by the neovim build.
PACKAGES+=" gperf" # Used by the fontconfig build.
PACKAGES+=" help2man"
PACKAGES+=" intltool" # Used by qalc build.
PACKAGES+=" glib2" # Provides 'glib-genmarshal' which the glib build uses.
PACKAGES+=" libtool"
PACKAGES+=" lzip"
PACKAGES+=" python"
PACKAGES+=" python2"
PACKAGES+=" tar"
PACKAGES+=" unzip"
PACKAGES+=" m4"
PACKAGES+=" pkgconf"
PACKAGES+=" python-docutils" # For rst2man, used by mpv.
PACKAGES+=" python-setuptools" # Needed by at least asciinema.
PACKAGES+=" python-sphinx" # Needed by notmuch man page generation.
PACKAGES+=" ruby" # Needed to build ruby.
PACKAGES+=" scons"
PACKAGES+=" texinfo"
PACKAGES+=" xmlto"
PACKAGES+=" expat" # Needed by ghostscript.
PACKAGES+=" libjpeg-turbo" # Needed by ghostscript.
PACKAGES+=" gawk" # Needed by apr-util.
PACKAGES+=" openssl"  # Needed to build rust.
PACKAGES+=" gnupg" # Needed to verify downloaded debs.
PACKAGES+=" jq" # Needed by bintray uploader script.
PACKAGES+=" lua" # Needed to build luarocks package.
PACKAGES+=" python-recommonmark" # Needed for LLVM-8 documentation.
PACKAGES+=" jre8-openjdk-headless"

sudo pacman -Syq --noconfirm $PACKAGES

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R $(whoami) /data

echo "Please also install ncurses5-compat-libs and makedepend packages from the AUR before continuing"
