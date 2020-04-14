TERMUX_PKG_HOMEPAGE=https://www.tarsnap.com/spiped.html
TERMUX_PKG_DESCRIPTION="a utility for creating symmetrically encrypted and authenticated pipes between socket addresses"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://github.com/Tarsnap/spiped/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c80a49b131aeb017c06dcc10e2461c25a333e1e32ed99a0bb6af169014306815
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
