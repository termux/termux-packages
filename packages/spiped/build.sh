TERMUX_PKG_HOMEPAGE=https://www.tarsnap.com/spiped.html
TERMUX_PKG_DESCRIPTION="a utility for creating symmetrically encrypted and authenticated pipes between socket addresses"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://github.com/Tarsnap/spiped/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=spiped-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="openssl"

termux_step_configure() {
	return
}

termux_step_make () {
	CFLAGS+=" -I/data/data/com.termux/files/usr/include"
	LDADD_EXTRA=" -L/data/data/com.termux/files/usr/lib" make BINDIR=$TERMUX_PREFIX/bin install
}

termux_step_make_install () {
	return
}
