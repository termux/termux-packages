TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/fontconfig/
TERMUX_PKG_DESCRIPTION="Library for configuring and customizing font access"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/fontconfig/release/fontconfig-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=298e883f6e11d2c5e6d53c8a8394de58d563902cfab934e6be12fb5a5f361ef0
TERMUX_PKG_DEPENDS="freetype, libxml2, libpng, libuuid (>> 2.38.1), ttf-dejavu, zlib"
TERMUX_PKG_BREAKS="fontconfig-dev"
TERMUX_PKG_REPLACES="fontconfig-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libxml2
--enable-iconv=no
--disable-docs
--with-default-fonts=/system/fonts
--with-add-fonts=$TERMUX_PREFIX/share/fonts
"
