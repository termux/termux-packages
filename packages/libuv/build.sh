TERMUX_PKG_HOMEPAGE=http://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.11.0
TERMUX_PKG_SRCURL=http://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0f686994dcea6cb5cd3f50e35d5fdda07211b4b3586516df7c39bdbf19acb9a7
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-dtrace" # needed for building on mac

termux_step_pre_configure () {
	export LINK=$CXX
	export PLATFORM=android
	sh autogen.sh
}
