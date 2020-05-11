TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.37.0
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6f2794313c9603388ed4b7b818b3bed5f784f886ae3ce5b3424b331813f6a391
TERMUX_PKG_BREAKS="libuv-dev"
TERMUX_PKG_REPLACES="libuv-dev"

termux_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
