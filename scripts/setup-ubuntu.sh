#!/bin/bash
set -e -u

PACKAGES=""
PACKAGES+=" asciidoc"
PACKAGES+=" asciidoctor" # Used by weechat for man pages.
PACKAGES+=" automake"
PACKAGES+=" bison"
PACKAGES+=" curl" # Used for fetching sources.
PACKAGES+=" ed" # Used by bc
PACKAGES+=" flex"
PACKAGES+=" g++-multilib" # Used by nodejs build for 32-bit arches.
PACKAGES+=" gettext" # Provides 'msgfmt' which the apt build uses.
PACKAGES+=" g++"
PACKAGES+=" git" # Used by the neovim build.
PACKAGES+=" gperf" # Used by the fontconfig build.
PACKAGES+=" help2man"
PACKAGES+=" intltool" # Used by qalc build.
PACKAGES+=" libglib2.0-dev" # Provides 'glib-genmarshal' which the glib build uses.
PACKAGES+=" libtool-bin"
PACKAGES+=" libncurses5-dev" # Used by mariadb for host build part.
PACKAGES+=" lzip"
PACKAGES+=" python3.7"
PACKAGES+=" tar"
PACKAGES+=" unzip"
PACKAGES+=" m4"
PACKAGES+=" openjdk-8-jdk-headless" # Used for android-sdk.
PACKAGES+=" pkg-config"
PACKAGES+=" python3-docutils" # For rst2man, used by mpv.
PACKAGES+=" python3-setuptools" # Needed by at least asciinema.
PACKAGES+=" python3-sphinx" # Needed by notmuch man page generation.
PACKAGES+=" ruby" # Needed to build ruby.
PACKAGES+=" scons"
PACKAGES+=" texinfo"
PACKAGES+=" xmlto"
PACKAGES+=" libexpat1-dev" # Needed by ghostscript
PACKAGES+=" libjpeg-dev" # Needed by ghostscript
PACKAGES+=" gawk" # Needed by apr-util
PACKAGES+=" libssl-dev" # Needed to build Rust
PACKAGES+=" gnupg" # Needed to verify downloaded .debs
PACKAGES+=" jq" # Needed by bintray upload script.
PACKAGES+=" lua5.3" # Needed to build luarocks package.
PACKAGES+=" python3-recommonmark" # needed for llvm-8 documentation
PACKAGES+=" llvm-7-tools" # so we don't build llvm for build

sudo DEBIAN_FRONTEND=noninteractive \
	apt-get install -yq --no-install-recommends $PACKAGES

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R $(whoami) /data
