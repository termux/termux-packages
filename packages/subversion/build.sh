TERMUX_PKG_HOMEPAGE=http://subversion.apache.org/
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_VERSION=1.8.13
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl --without-libmagic"

# subversion compiles with std=c90, but the NDK asm/byteorder.h uses C99 inline:
CFLAGS+=" -std=c99"
