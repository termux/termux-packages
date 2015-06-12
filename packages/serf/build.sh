TERMUX_PKG_HOMEPAGE=https://code.google.com/p/serf/
TERMUX_PKG_DESCRIPTION="High performance C-based HTTP client library"
TERMUX_PKG_VERSION=1.3.8
TERMUX_PKG_SRCURL=http://serf.googlecode.com/svn/src_releases/serf-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="apr-util, openssl"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {
	scons APR=$TERMUX_PREFIX \
	      APU=$TERMUX_PREFIX \
	      CC=`which $CC` \
	      CFLAGS="$CFLAGS -std=c99" \
	      CPPFLAGS="$CPPFLAGS" \
	      LINKFLAGS="$LDFLAGS" \
	      OPENSSL=$TERMUX_PREFIX \
              PREFIX=$TERMUX_PREFIX \
	      install
}
