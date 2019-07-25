#!/bin/bash
set -e -u

PACKAGES=""
PACKAGES+=" asciidoc"
PACKAGES+=" asciidoctor" # Used by weechat for man pages.
PACKAGES+=" automake"
PACKAGES+=" autopoint"
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
PACKAGES+=" libdbus-1-dev" # Used by dbus-glib build.
PACKAGES+=" libglib2.0-dev" # Provides 'glib-genmarshal' which the glib build uses.
PACKAGES+=" libc-ares-dev" # Used by host build part of nodejs v12.6.0+.
PACKAGES+=" libicu-dev" # Used by host build part of nodejs v12.6.0+.
PACKAGES+=" libtool-bin"
PACKAGES+=" libncurses5-dev" # Used by mariadb for host build part.
PACKAGES+=" lzip"
PACKAGES+=" python3.7"
PACKAGES+=" tar"
PACKAGES+=" unzip"
PACKAGES+=" m4"
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
PACKAGES+=" llvm-8-tools" # so we don't build llvm for build
PACKAGES+=" valac" # for ccnet
PACKAGES+=" openssl" # Needed by swi-prolog
PACKAGES+=" libssl-dev:i386" # Needed by swi-prolog 32-bit
PACKAGES+=" zlib1g-dev:i386"

# Allow 32-bit packages.
sudo dpkg --add-architecture i386
sudo apt-get -yq update

sudo DEBIAN_FRONTEND=noninteractive \
	apt-get install -yq --no-install-recommends $PACKAGES

# Find and assign UBUNTU_VERSION
if [[ `lsb_release -rs` == "19.04" ]]; then
	UBUNTU_VERSION="19.04.2"
else
	UBUNTU_VERSION="18.10.1"
fi

# Make openjdk 8 available:
curl -O http://security.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jdk-headless_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb
curl -O http://security.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jdk_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb
curl -O http://security.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb
curl -O http://security.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre-headless_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb
sudo dpkg -i openjdk-8-jre-headless_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb openjdk-8-jre_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb openjdk-8-jdk_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb openjdk-8-jdk-headless_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb || sudo apt install -f -y
rm openjdk-8-jre-headless_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb openjdk-8-jre_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb openjdk-8-jdk_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb openjdk-8-jdk-headless_8u212-b03-0ubuntu1."$UBUNTU_VERSION"_amd64.deb

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R $(whoami) /data
