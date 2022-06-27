TERMUX_PKG_HOMEPAGE=http://pngwriter.sourceforge.net
TERMUX_PKG_DESCRIPTION="C++ library for creating PNG images"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/pngwriter/pngwriter/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=82d46eef109f434f95eba9cf5908710ae4e75f575fd3858178ad06e800152825
TERMUX_PKG_DEPENDS="zlib,freetype,libpng"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_make_install() {
        mv "$TERMUX_PREFIX"/lib/libPNGwriter_shared.so libPNGwriter.so
}
