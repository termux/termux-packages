TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.30.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=468316fa841d114114f167b45d1f43d46a2a1852d8464336a4abbbf5b88b478b
TERMUX_PKG_BREAKS="libuv-dev"
TERMUX_PKG_REPLACES="libuv-dev"
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
