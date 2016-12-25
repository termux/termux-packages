TERMUX_PKG_HOMEPAGE=http://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.10.1
TERMUX_PKG_SRCURL=http://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4886badd96dcc74debbb5736381960f22bae2308166bc0a1074bcd6d364d1a7f
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-dtrace" # needed for building on mac

termux_step_pre_configure () {
	export LINK=$CXX
	export PLATFORM=android
	cd $TERMUX_PKG_SRCDIR
	sh autogen.sh
}
