TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.29.0
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f7bf07c82efe991eeddaf70ee8fa753f9b6a9a699d1fb7a08aceb8659dd7547f

termux_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
