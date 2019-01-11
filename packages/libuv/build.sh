TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.24.1
TERMUX_PKG_SHA256=3dd3eeb7b00214b0226da55b38898d3f9481d0cf744d42faf82771e0f19f2b0a
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	export PLATFORM=android
	sh autogen.sh
}
