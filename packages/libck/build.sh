TERMUX_PKG_HOMEPAGE=https://github.com/concurrencykit/ck
TERMUX_PKG_DESCRIPTION="A concurrency primitives, safe memory reclamation mechanisms C library"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.2"
TERMUX_PKG_SRCURL=https://github.com/concurrencykit/ck/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=568ebe0bc1988a23843fce6426602e555b7840bf6714edcdf0ed530214977f1b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_configure() {
	./configure \
		--prefix=$TERMUX_PREFIX \
		--platform=$TERMUX_ARCH
}
