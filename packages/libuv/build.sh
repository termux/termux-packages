TERMUX_PKG_HOMEPAGE=http://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.18.0
TERMUX_PKG_SHA256=54e4734da09172f19d5061dcfd7a536fe4c3a8dc12ed981a14a58ac17efdab88
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	export PLATFORM=android
	sh autogen.sh
}
