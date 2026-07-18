# Contributor: @DLC01
TERMUX_PKG_HOMEPAGE=https://github.com/nu774/fdkaac
TERMUX_PKG_DESCRIPTION="command line encoder frontend for libfdk-aac"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.8"
TERMUX_PKG_SRCURL=https://github.com/nu774/fdkaac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=25baf7bd9ae697d1c2673bbf4b1348b337258ef487c2bd0572451539fb38ebbf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libfdk-aac"

termux_step_pre_configure() {
	autoreconf -fi
}
