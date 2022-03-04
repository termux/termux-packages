TERMUX_PKG_HOMEPAGE=https://www.tarsnap.com/spiped.html
TERMUX_PKG_DESCRIPTION="a utility for creating symmetrically encrypted and authenticated pipes between socket addresses"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/Tarsnap/spiped/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d14a0c802f97bfe4da6c1a6c1ec882b7ffb94d28aee1eea11e6ad532fc21254c
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make () {
	CFLAGS+=" $CPPFLAGS"
	env LDADD_EXTRA="$LDFLAGS" \
		make -j "$TERMUX_MAKE_PROCESSES" BINDIR="$TERMUX_PREFIX/bin" \
			MAN1DIR="$TERMUX_PREFIX/share/man/man1"
}

termux_step_make_install() {
	make install BINDIR="$TERMUX_PREFIX/bin" \
		MAN1DIR="$TERMUX_PREFIX/share/man/man1"
}
