#!/bin/sh

PACKAGES=""
PACKAGES="$PACKAGES asciidoc"
PACKAGES="$PACKAGES automake"
PACKAGES="$PACKAGES bison"
PACKAGES="$PACKAGES cmake"
PACKAGES="$PACKAGES curl"			    # Used for fetching sources.
PACKAGES="$PACKAGES flex"
PACKAGES="$PACKAGES gettext"			# Provides 'msgfmt' which the apt build uses.
PACKAGES="$PACKAGES git"			    # Used by the neovim build.
PACKAGES="$PACKAGES help2man"
PACKAGES="$PACKAGES glibc-devel.i686"	# Needed by luajit host part of the build for <sys/cdefs.h>.
PACKAGES="$PACKAGES libcurl-devel"	    # XXX: Needed by apt build.
PACKAGES="$PACKAGES gdk-pixbuf2-devel"	# Provides 'gkd-pixbuf-query-loaders' which the librsvg build uses.
PACKAGES="$PACKAGES glib2-devel"		# Provides 'glib-genmarshal' which the glib build uses.
PACKAGES="$PACKAGES ncurses-devel"
PACKAGES="$PACKAGES libtool"
PACKAGES="$PACKAGES lzip"
PACKAGES="$PACKAGES subversion"			# Used by the netpbm build.
PACKAGES="$PACKAGES tar"
PACKAGES="$PACKAGES unzip"
PACKAGES="$PACKAGES m4"
PACKAGES="$PACKAGES java-1.8.0-openjdk"	# Used for android-sdk.
PACKAGES="$PACKAGES pkgconfig"
PACKAGES="$PACKAGES scons"
PACKAGES="$PACKAGES texinfo"
PACKAGES="$PACKAGES xmlto"
PACKAGES="$PACKAGES imake"	            # Provides 'makedepend' which the openssl build uses.
sudo dnf install -y $PACKAGES

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R `whoami` /data
