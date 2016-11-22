TERMUX_PKG_HOMEPAGE=http://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.10.0
TERMUX_PKG_SRCURL=http://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0307a0eec6caddd476f9cad39e18fdd6f22a08aa58103c4b0aead96d638be15e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-dtrace" # needed for building on mac

termux_step_pre_configure () {
	export LINK=$CXX
	export PLATFORM=android
	cd $TERMUX_PKG_SRCDIR
	sh autogen.sh
}
