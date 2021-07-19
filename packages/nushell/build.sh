TERMUX_PKG_HOMEPAGE=https://www.nushell.sh
TERMUX_PKG_DESCRIPTION="A new type of shell operating on structured data"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.34.0
TERMUX_PKG_SRCURL=https://github.com/nushell/nushell/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9571c7fbf0f0fdabb055727b63b6a5c3561f04357336289106591fc6afcff7a3
TERMUX_PKG_DEPENDS="openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = "i686" ]; then
		RUSTFLAGS+=" -C link-arg=-latomic"
	fi
}
