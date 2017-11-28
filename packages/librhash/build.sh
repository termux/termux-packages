TERMUX_PKG_HOMEPAGE=http://rhash.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Console utility for calculation and verification of magnet links and a wide range of hash sums"
TERMUX_PKG_VERSION=1.3.5
TERMUX_PKG_SHA256=98e0688acae29e68c298ffbcdbb0f838864105f9b2bd8857980664435b1f1f2e
TERMUX_PKG_SRCURL=https://github.com/rhash/RHash/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"

# we only build the library since we don't need the binary
termux_step_make () {
	CFLAGS="-DOPENSSL_RUNTIME $CPPFLAGS $CFLAGS"
	make lib-shared -j $TERMUX_MAKE_PROCESSES \
		ADDCFLAGS="$CFLAGS" \
		ADDLDFLAGS="$LDFLAGS"
}

termux_step_make_install () {
	make -C librhash install-lib-shared install-headers PREFIX=$TERMUX_PREFIX
	ln -sf $TERMUX_PREFIX/lib/librhash.so.0 $TERMUX_PREFIX/lib/librhash.so
}
