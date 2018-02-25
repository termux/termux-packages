TERMUX_PKG_HOMEPAGE=http://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.19.2
TERMUX_PKG_SHA256=7cbcf2017e7116cf9da8ec1c6a146d578536b1e479458438873c991f984a53d7
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	export PLATFORM=android
	sh autogen.sh
}
