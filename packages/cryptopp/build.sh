TERMUX_PKG_HOMEPAGE=https://www.cryptopp.com/
TERMUX_PKG_DESCRIPTION="A free C++ class library of cryptographic schemes"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=8.4.0
TERMUX_PKG_SRCURL=https://www.cryptopp.com/cryptopp${TERMUX_PKG_VERSION//./}.zip
TERMUX_PKG_SHA256=c0f5e5cd2c693c8160e9c51666e95949a1c19fd4fe4fef874af2ec1e42757b9a
TERMUX_PKG_BREAKS="cryptopp-dev"
TERMUX_PKG_REPLACES="cryptopp-dev"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_RM_AFTER_INSTALL="
bin/
share/cryptopp/
"

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_CACHEDIR
	termux_download $TERMUX_PKG_SRCURL $TERMUX_PKG_CACHEDIR/cryptopp.zip \
		$TERMUX_PKG_SHA256
	mkdir -p $TERMUX_PKG_SRCDIR
}

termux_step_post_get_source() {
	cd $TERMUX_PKG_SRCDIR
	unzip $TERMUX_PKG_CACHEDIR/cryptopp.zip
}

termux_step_make() {
	CXXFLAGS+=" -fPIC -DCRYPTOPP_DISABLE_ASM"
	make -j $TERMUX_MAKE_PROCESSES dynamic libcryptopp.pc CC=$CC CXX=$CXX
}

termux_step_make_install() {
	make install-lib PREFIX=$TERMUX_PREFIX
}
