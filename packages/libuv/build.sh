TERMUX_PKG_HOMEPAGE=http://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.20.2
TERMUX_PKG_SHA256=6b75ac191d6c5ac520bbb9acc4ec93bee48cfb8527744a66759596f3e04f0322
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	export PLATFORM=android
	sh autogen.sh
}
