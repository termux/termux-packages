TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.28.0
TERMUX_PKG_SHA256=30af87a2d6052047192ec6460398f93716f8b71268367e08662a6ef7a27e06ad
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
