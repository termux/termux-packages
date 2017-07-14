TERMUX_PKG_HOMEPAGE=http://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.13.1
TERMUX_PKG_SRCURL=http://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=824fe07476a9cab519d2d3e2be6d49f1faa1e7bb59224f0d81a7d6a307ce3937

termux_step_pre_configure () {
	export PLATFORM=android
	sh autogen.sh
}
