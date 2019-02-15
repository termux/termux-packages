TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.26.0
TERMUX_PKG_SHA256=caf817a7fb7f3fd1a2fe1517c777327fa76f04b36afc46238ad609f0148014e7
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
