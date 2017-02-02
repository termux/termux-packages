#!/bin/sh

PACKAGES[0]=""
PACKAGES[1]="ant"			# Used by jack and aptsigner.
PACKAGES[2]="asciidoc"
PACKAGES[3]="automake"
PACKAGES[4]="bison"
PACKAGES[5]="clang"			# Used by golang, useful to have same compiler building.
PACKAGES[6]="curl"			# Used for fetching sources.
PACKAGES[7]="flex"
PACKAGES[8]="gettext"			# Provides 'msgfmt' which the apt build uses.
PACKAGES[9]="git"			# Used by the neovim build.
PACKAGES[10]="help2man"
PACKAGES[11]="intltool"			# Used by qalc build.
PACKAGES[12]="libgdk-pixbuf2.0-dev"	# Provides 'gkd-pixbuf-query-loaders' which the librsvg build uses.
PACKAGES[13]="libglib2.0-dev"		# Provides 'glib-genmarshal' which the glib build uses.
PACKAGES[14]="libtool-bin"
PACKAGES[15]="lzip"
PACKAGES[16]="python3.6"
PACKAGES[17]="subversion"			# Used by the netpbm build.
PACKAGES[18]="tar"
PACKAGES[19]="unzip"
PACKAGES[20]="m4"
PACKAGES[21]="openjdk-8-jdk"		# Used for android-sdk.
PACKAGES[22]="pkg-config"
PACKAGES[23]="python-docutils"		# For rst2man, used by mpv.
PACKAGES[24]="scons"
PACKAGES[25]="texinfo"
PACKAGES[26]="xmlto"
PACKAGES[27]="xutils-dev"			# Provides 'makedepend' which the openssl build uses.

for i in {1..27}
do
PACKAGES[$i]="${PACKAGES[$(($i-1))]} ${PACKAGES[$i]}"
done

DEBIAN_FRONTEND=noninteractive sudo apt-get install -yq $PACKAGES[$i]

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R `whoami` /data
