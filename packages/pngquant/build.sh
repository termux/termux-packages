TERMUX_PKG_HOMEPAGE=https://pngquant.org
TERMUX_PKG_DESCRIPTION="PNG image optimising utility"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.17.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/kornelski/pngquant/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bc1baa43c814b4416bb63d7b2168d4e5395cfc69a00f8997a595361caa507887
TERMUX_PKG_DEPENDS="libimagequant, libpng, littlecms"
TERMUX_PKG_BUILD_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-libimagequant
--disable-sse
"

termux_step_post_get_source() {
	rm -rf lib
}
