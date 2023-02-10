TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/fontconfig/
TERMUX_PKG_DESCRIPTION="Library for configuring and customizing font access"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/fontconfig/release/fontconfig-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=dba695b57bce15023d2ceedef82062c2b925e51f5d4cc4aef736cf13f60a468b
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
