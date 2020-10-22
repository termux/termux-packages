TERMUX_PKG_HOMEPAGE=https://www.cryptopp.com/
TERMUX_PKG_DESCRIPTION="A free C++ class library of cryptographic schemes"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=8.2.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://www.cryptopp.com/cryptopp${TERMUX_PKG_VERSION//./}.zip
TERMUX_PKG_SHA256=03f0e2242e11b9d19b28d0ec5a3fa8ed5cc7b27640e6bed365744f593e858058
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
