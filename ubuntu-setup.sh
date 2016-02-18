#!/bin/sh

PACKAGES=""
PACKAGES="$PACKAGES asciidoc"
PACKAGES="$PACKAGES automake"
PACKAGES="$PACKAGES bison"
PACKAGES="$PACKAGES cmake"
PACKAGES="$PACKAGES curl"			# Used for fetching sources
PACKAGES="$PACKAGES flex"
PACKAGES="$PACKAGES gettext"			# Provides 'msgfmt' which the apt build uses
PACKAGES="$PACKAGES help2man"
PACKAGES="$PACKAGES libc6-dev-i386"		# Needed by luajit host part of the build for <sys/cdefs.h>
PACKAGES="$PACKAGES libcurl4-openssl-dev"	# Needed by apt build
PACKAGES="$PACKAGES libgdk-pixbuf2.0-dev"	# Provides 'gkd-pixbuf-query-loaders' which the librsvg build uses
PACKAGES="$PACKAGES libglib2.0-dev"		# Provides 'glib-genmarshal' which the glib build uses
PACKAGES="$PACKAGES libncurses5-dev"
PACKAGES="$PACKAGES libtool"
PACKAGES="$PACKAGES lzip"
PACKAGES="$PACKAGES m4"
PACKAGES="$PACKAGES pkg-config"
PACKAGES="$PACKAGES scons"
PACKAGES="$PACKAGES texinfo"
PACKAGES="$PACKAGES xmlto"
PACKAGES="$PACKAGES xutils-dev"			# Provides u'makedepend' which the openssl build uses
PACKAGES="$PACKAGES git"
sudo apt install $PACKAGES

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R $USER /data
