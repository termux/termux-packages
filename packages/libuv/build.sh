TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_LICENSE="MIT, BSD 2-Clause, ISC, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.51.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5f0557b90b1106de71951a3c3931de5e0430d78da1d9a10287ebc7a3f78ef8eb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libuv-dev"
TERMUX_PKG_REPLACES="libuv-dev"

termux_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
