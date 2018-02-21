TERMUX_PKG_HOMEPAGE=http://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.19.1
TERMUX_PKG_SHA256=32ed9944364ecf25e4b75227e5ee5709110423ba80a5c7d7e5123ab89300e878
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	export PLATFORM=android
	sh autogen.sh
}
