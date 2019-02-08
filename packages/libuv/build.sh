TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.25.0
TERMUX_PKG_SHA256=0e927ddc0f1c83899000a63e9286cac5958222f8fb5870a49b0c81804944a912
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
