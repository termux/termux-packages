TERMUX_PKG_HOMEPAGE=https://github.com/jmacd/xdelta
TERMUX_PKG_DESCRIPTION="xdelta3 - VCDIFF (RFC 3284) binary diff tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.1"
TERMUX_PKG_SRCURL="https://github.com/jmacd/xdelta/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=dc75f6a9615ac278fe00375d94241f47af4e893f11e4a9f46b4ca4e2e1f99e66
TERMUX_PKG_DEPENDS="liblzma"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_post_get_source() {
	# xdelta3's source code lives in a subdirectory inside its repository/tarball
	TERMUX_PKG_SRCDIR+=/xdelta3
}

termux_step_pre_configure() {
	CPPFLAGS+=" -DXD3_USE_LARGEFILE64 -D_FILE_OFFSET_BITS=64"
}
