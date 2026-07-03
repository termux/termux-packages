TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/exo/start
TERMUX_PKG_DESCRIPTION="Application library for XFCE"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.21.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/exo/${TERMUX_PKG_VERSION%.*}/exo-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=26f85ca2db3bcf99d8b8af28b0d565b0186ccc3d2ed4a5ba315f6a589b8bc2c9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="xfce4-dev-tools"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_CONFLICTS="libexo"
TERMUX_PKG_REPLACES="libexo"
TERMUX_PKG_PROVIDES="libexo"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--enable-gtk-doc-html=no
"
