TERMUX_PKG_HOMEPAGE=https://github.com/rhash/RHash
TERMUX_PKG_DESCRIPTION="Console utility for calculation and verification of magnet links and a wide range of hash sums"
TERMUX_PKG_VERSION=1.3.6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=964df972b60569b5cb35ec989ced195ab8ea514fc46a74eab98e86569ffbcf92
TERMUX_PKG_SRCURL=https://github.com/rhash/RHash/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_CONFLICTS=librhash
TERMUX_PKG_REPLACES=librhash

termux_step_make () {
	CFLAGS="-DOPENSSL_RUNTIME $CPPFLAGS $CFLAGS"
	make -j $TERMUX_MAKE_PROCESSES \
		ADDCFLAGS="$CFLAGS" \
		ADDLDFLAGS="$LDFLAGS"
}

termux_step_make_install () {
	make install install-pkg-config
	make -C librhash install-headers

	ln -sf $TERMUX_PREFIX/lib/librhash.so.0 $TERMUX_PREFIX/lib/librhash.so
}
