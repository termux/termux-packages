TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/fontconfig/
TERMUX_PKG_DESCRIPTION="Library for configuring and customizing font access"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.16.1"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/$TERMUX_PKG_VERSION/fontconfig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=570e70cc481b871683dec38040d6a40a08068c685277cae9ad7ec5a717040203
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, libexpat, ttf-dejavu"
TERMUX_PKG_BREAKS="fontconfig-dev"
TERMUX_PKG_REPLACES="fontconfig-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libxml2=no
--enable-iconv=no
--disable-docs
--with-default-fonts=/system/fonts
--with-add-fonts=$TERMUX_PREFIX/share/fonts
"

termux_step_pre_configure() {
	autoreconf -fi
}
