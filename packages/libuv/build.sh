TERMUX_PKG_HOMEPAGE=https://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_LICENSE="MIT, BSD 2-Clause, ISC, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.48.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7f1db8ac368d89d1baf163bac1ea5fe5120697a73910c8ae6b2fffb3551d59fb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libuv-dev"
TERMUX_PKG_REPLACES="libuv-dev"

termux_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
