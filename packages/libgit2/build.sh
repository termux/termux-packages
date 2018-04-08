TERMUX_PKG_HOMEPAGE=https://libgit2.github.com/
TERMUX_PKG_DESCRIPTION="C library implementing Git core methods"
TERMUX_PKG_VERSION=0.27.0
TERMUX_PKG_SHA256=545b0458292c786aba334f1bf1c8f73600ae73dd7205a7bb791a187ee48ab8d2
TERMUX_PKG_SRCURL=https://github.com/libgit2/libgit2/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libcurl, openssl"
TERMUX_PKG_REVISION=1
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_CLAR=OFF"

termux_step_pre_configure() {
	# Fixes for arm https://github.com/android-ndk/ndk/issues/642
	# Can be removed after updating to NDK r17.
	if [ $TERMUX_ARCH = "arm" ]; then
		CFLAGS+=" -mllvm -arm-promote-constant=0"
	fi
}
