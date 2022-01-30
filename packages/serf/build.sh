TERMUX_PKG_HOMEPAGE=https://serf.apache.org/
TERMUX_PKG_DESCRIPTION="High performance C-based HTTP client library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.9
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://archive.apache.org/dist/serf/serf-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=549c2d21c577a8a9c0450facb5cca809f26591f048e466552240947bdf7a87cc
TERMUX_PKG_DEPENDS="apr, apr-util, openssl, libuuid, libexpat, zlib"
TERMUX_PKG_BREAKS="serf-dev"
TERMUX_PKG_REPLACES="serf-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	scons APR=$TERMUX_PREFIX \
	      APU=$TERMUX_PREFIX \
	      CC=$(command -v $CC) \
	      CFLAGS="$CFLAGS" \
	      CPPFLAGS="$CPPFLAGS -std=c11" \
	      LINKFLAGS="$LDFLAGS" \
	      OPENSSL=$TERMUX_PREFIX \
	      PREFIX=$TERMUX_PREFIX \
	      install
	# Avoid specifying -lcrypt:
	perl -p -i -e 's/-lcrypt //' $TERMUX_PREFIX/lib/pkgconfig/serf-1.pc
}
