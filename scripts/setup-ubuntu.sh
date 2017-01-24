#!/bin/sh

PACKAGES=""
PACKAGES="$PACKAGES ant"			# Used by jack and aptsigner.
PACKAGES="$PACKAGES asciidoc"
PACKAGES="$PACKAGES automake"
PACKAGES="$PACKAGES bison"
PACKAGES="$PACKAGES clang"			# Used by golang, useful to have same compiler building.
PACKAGES="$PACKAGES curl"			# Used for fetching sources.
PACKAGES="$PACKAGES flex"
PACKAGES="$PACKAGES gettext"			# Provides 'msgfmt' which the apt build uses.
PACKAGES="$PACKAGES git"			# Used by the neovim build.
PACKAGES="$PACKAGES help2man"
PACKAGES="$PACKAGES intltool"			# Used by qalc build.
PACKAGES="$PACKAGES libgdk-pixbuf2.0-dev"	# Provides 'gkd-pixbuf-query-loaders' which the librsvg build uses.
PACKAGES="$PACKAGES libglib2.0-dev"		# Provides 'glib-genmarshal' which the glib build uses.
PACKAGES="$PACKAGES libtool-bin"
PACKAGES="$PACKAGES lzip"
PACKAGES="$PACKAGES python3.6"
PACKAGES="$PACKAGES subversion"			# Used by the netpbm build.
PACKAGES="$PACKAGES tar"
PACKAGES="$PACKAGES unzip"
PACKAGES="$PACKAGES m4"
PACKAGES="$PACKAGES openjdk-8-jdk"		# Used for android-sdk.
PACKAGES="$PACKAGES pkg-config"
PACKAGES="$PACKAGES python-docutils"		# For rst2man, used by mpv.
PACKAGES="$PACKAGES scons"
PACKAGES="$PACKAGES texinfo"
PACKAGES="$PACKAGES xmlto"
PACKAGES="$PACKAGES xutils-dev"			# Provides 'makedepend' which the openssl build uses.

DEBIAN_FRONTEND=noninteractive sudo apt-get install -yq $PACKAGES

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R `whoami` /data
