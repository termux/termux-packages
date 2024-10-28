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
PACKAGES+=" go-md2man"
PACKAGES+=" groff"
PACKAGES+=" help2man"
PACKAGES+=" pandoc"
PACKAGES+=" python3-docutils"
PACKAGES+=" python3-recommonmark"
PACKAGES+=" python3-myst-parser"
PACKAGES+=" python3-sphinx"
PACKAGES+=" python3-sphinx-rtd-theme"
PACKAGES+=" python3-sphinxcontrib.qthelp"
PACKAGES+=" scdoc"
PACKAGES+=" texinfo"
PACKAGES+=" txt2man"
PACKAGES+=" xmlto"
PACKAGES+=" xmltoman"

# Needed by python modules (e.g. asciinema) and some build systems.
PACKAGES+=" python3-pip"
PACKAGES+=" python3-setuptools"
PACKAGES+=" python-wheel-common"
PACKAGES+=" python3.12-venv"

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
PACKAGES+=" libc-ares-dev:i386"
PACKAGES+=" libicu-dev"
PACKAGES+=" libsqlite3-dev:i386"

# Needed by php.
PACKAGES+=" re2c"

# Needed by composer.
PACKAGES+=" php"
PACKAGES+=" php-xml"
PACKAGES+=" composer"

# Needed by package rust.
PACKAGES+=" libssl-dev" # Needed to build Rust
PACKAGES+=" llvm-17-dev"
PACKAGES+=" llvm-17-tools"
PACKAGES+=" clang-17"

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

# needed by ovmf
PACKAGES+=" libarchive-tools"

# Needed by cavif-rs
PACKAGES+=" nasm"

# Needed by debianutils
PACKAGES+=" po4a"

# Needed by dgsh
PACKAGES+=" rsync"

# Needed by megacmd
PACKAGES+=" wget"

# Needed by codeblocks
PACKAGES+=" libwxgtk3.2-dev"
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
PACKAGES+=" python3-html5lib"
PACKAGES+=" python3-xcbgen"
PACKAGES+=" sassc"
PACKAGES+=" texlive-extra-utils"
PACKAGES+=" unifdef"
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

# Needed by package gdb.
PACKAGES+=" guile-3.0-dev"

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

# Required by openjdk-21
PACKAGES+=" openjdk-21-jre openjdk-21-jdk"

# Required by qt5-qtwebengine
PACKAGES+=" libnss3 libnss3:i386 libnss3-dev"
PACKAGES+=" libwebp7 libwebp7:i386 libwebp-dev"
PACKAGES+=" libwebpdemux2 libwebpdemux2:i386"
PACKAGES+=" libwebpmux3 libwebpmux3:i386"

# Required by wine-stable
PACKAGES+=" libfreetype-dev:i386"

# Required by CGCT
PACKAGES+=" libdebuginfod-dev"

# Needed to set up CGCT and also to set up other packages
PACKAGES+=" patchelf"

# Needed by lldb for python integration
PACKAGES+=" swig"

# Needed by binutils-cross
PACKAGES+=" libzstd-dev"

# Do not require sudo if already running as root.
SUDO="sudo"
if [ "$(id -u)" = "0" ]; then
	SUDO=""
fi

# Allow 32-bit packages.
$SUDO dpkg --add-architecture i386

# Add apt.llvm.org repo to get newer LLVM than Ubuntu provided
$SUDO cp $(dirname "$(realpath "$0")")/llvm-snapshot.gpg.key /etc/apt/trusted.gpg.d/apt.llvm.org.asc
$SUDO chmod a+r /etc/apt/trusted.gpg.d/apt.llvm.org.asc
{
	echo "deb [arch=amd64] http://apt.llvm.org/noble/ llvm-toolchain-noble-17 main"
} | $SUDO tee /etc/apt/sources.list.d/apt-llvm-org.list > /dev/null

# Add deadsnakes PPA to enable installing python 3.11:
$SUDO add-apt-repository -y 'ppa:deadsnakes/ppa'

$SUDO apt-get -yq update

$SUDO env DEBIAN_FRONTEND=noninteractive \
	apt-get install -yq --no-install-recommends $PACKAGES

# Reinstall the older implementation of pkg-config from Ubuntu 22.04 in order to
# avoid a bug with the command
# /home/builder/.termux-build/_cache/android-r27b-api-24-v1/bin/pkg-config --cflags protobuf
# ($PKG_CONFIG --cflags protobuf)
# involving the abseil-cpp pkg-config files
# during the build of the libprotobuf-c package.
# The older implementation parses the abseil-cpp pkg-config files correctly,
# but the new implementation, pkgconf, is resulting in "-Wno-float-conversion -DNOMINMAX"
# repeated 632,438 times which is not what the older implementation prints.
# https://gitea.treehouse.systems/ariadne/pkgconf/issues/229
# https://github.com/termux/termux-packages/issues/21995

# Function to obtain the .deb URL, by twaik from
# https://github.com/termux/termux-packages/pull/21825/commits/8efe9c69039a698b69781c3330e31a4958387ca1
obtain_deb_url() {
	# jammy is last known Ubuntu distro which contains pkg-config version 0.29.2 in packages
	local url="https://packages.ubuntu.com/jammy/amd64/$1/download"
	local retries=5
	local wait=5
	local attempt
	local deb_url

	for ((attempt=1; attempt<=retries; attempt++)); do
		local PAGE="$(curl -s "$url")"
		>&2 echo page
		>&2 echo "$PAGE"
		if deb_url=$(echo "$PAGE" | grep -Eo 'http://.*\.deb' | head -n 1); then
			if [[ -n "$deb_url" ]]; then
				echo "$deb_url"
				return 0
			else
				>&2 echo "Attempt $attempt: Received empty URL or server answered with 'Internal server error' page. Retrying in $wait seconds..."
			fi
		else
			>&2 echo "Attempt $attempt: Command failed. Retrying in $wait seconds..."
		fi
		sleep "$wait"
	done

	>&2 echo "Failed to obtain URL after $retries attempts."
	exit 1
}		

PC_URL="$(obtain_deb_url pkg-config)"
PC_TMPDIR="$HOME/legacy-pkg-config-tmp"
PC_DEB="$PC_TMPDIR/legacy-pkg-config.deb"
mkdir -p "$PC_TMPDIR"
wget "$PC_URL" -O "$PC_DEB"
ar x "$PC_DEB" --output="$PC_TMPDIR"
tar xf "$PC_TMPDIR/data.tar.zst" -C "$PC_TMPDIR"
# Directory contains this:
#legacy-pkg-config-tmp/usr/
#├── bin
#│   ├── pkg-config
#│   └── x86_64-pc-linux-gnu-pkg-config
#├── lib
#│   ├── pkgconfig
#│   └── pkg-config.multiarch
#└── share
#    ├── aclocal
#    │   └── pkg.m4
#    ├── doc
#    │   └── pkg-config
#    │       ├── AUTHORS
#    │       ├── changelog.Debian.gz
#    │       ├── copyright
#    │       ├── NEWS.gz
#    │       ├── pkg-config-guide.html
#    │       └── README
#    ├── man
#    │   └── man1
#    │       └── pkg-config.1.gz
#    ├── pkgconfig
#    ├── pkg-config-crosswrapper
#    └── pkg-config-dpkghook
#
# since only the usr/bin/pkg-config binary is needed for the workaround
# to be successful in this situation, it seems to me that it is fine to install
# only that file. This overwrites the symlink to pkgconf that Ubuntu 24.04 normally has
# with a copy of the legacy implementation of the pkg-config program,
# identifiable by version "0.29.2"
# The reason why I believe it is necessary to globally install this is
# because any other package besides libprotobuf-c that attempts to invoke
# the command "$PKG_CONFIG --cflags protobuf" will be affected by the same
# issue if this is not also applied to it.
$SUDO install -DTm755 "$PC_TMPDIR/usr/bin/pkg-config" /usr/bin/pkg-config
rm -rf "$PC_TMPDIR"

$SUDO locale-gen --purge en_US.UTF-8
echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' | $SUDO tee -a /etc/default/locale

. $(dirname "$(realpath "$0")")/properties.sh
$SUDO mkdir -p $TERMUX_PREFIX
$SUDO chown -R $(whoami) /data
$SUDO ln -sf /data/data/com.termux/files/usr/opt/bionic-host /system
