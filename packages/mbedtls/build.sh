TERMUX_PKG_HOMEPAGE=https://tls.mbed.org/
TERMUX_PKG_DESCRIPTION="Light-weight cryptographic and SSL/TLS library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=2.21.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_BREAKS="mbedtls-dev"
TERMUX_PKG_REPLACES="mbedtls-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_STATIC_MBEDTLS_LIBRARY=OFF
-DUSE_SHARED_MBEDTLS_LIBRARY=ON
-DENABLE_TESTING=OFF
-DENABLE_PROGRAMS=OFF
"

termux_step_extract_package() {
	local CHECKED_OUT_FOLDER=$TERMUX_PKG_CACHEDIR/checkout-$TERMUX_PKG_VERSION
	if [ ! -d $CHECKED_OUT_FOLDER ]; then
		local TMP_CHECKOUT=$TERMUX_PKG_TMPDIR/tmp-checkout
		rm -Rf $TMP_CHECKOUT
		mkdir -p $TMP_CHECKOUT

		git clone --depth 1 \
			--branch mbedtls-$TERMUX_PKG_VERSION \
			https://github.com/ARMmbed/mbedtls.git \
			$TMP_CHECKOUT
		cd $TMP_CHECKOUT
		git submodule update --init # --depth 1
		mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	mkdir $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER/* .
}
