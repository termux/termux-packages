TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.27.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=8d887047a3670606f6b87e5acdee586caccc6157331096c9c8e102804488cdca
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
