TERMUX_PKG_HOMEPAGE=https://github.com/aperezdc/signify
TERMUX_PKG_DESCRIPTION="Lightweight cryptographic signing and verifying tool"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="33"
TERMUX_PKG_SRCURL=https://github.com/aperezdc/signify/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2eff30861d82231f8e2b8f0320a3e5b4e1eab5b3a63def1ac7893e33dbd6f969
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libbsd"
TERMUX_PKG_BUILD_DEPENDS="libbsd"

termux_step_pre_configure() {
	CFLAGS+=" -DBYTE_ORDER=LITTLE_ENDIAN -Wno-implicit-function-declaration"
}
