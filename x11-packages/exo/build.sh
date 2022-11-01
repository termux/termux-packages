TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Application library for XFCE"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.17
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/exo/${_MAJOR_VERSION}/exo-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b0e1d78e773bf1b3ed24c07a20359c22536bde312369a65ac473bde47c899304
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-shmem, libcairo, libice, libpixman, libpng, libsm, libx11, libxcb, libxext, libxfce4ui, libxfce4util, libxrender, pango, zlib"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_CONFLICTS="libexo"
TERMUX_PKG_REPLACES="libexo"
TERMUX_PKG_PROVIDES="libexo"
TERMUX_PKG_RM_AFTER_INSTALL="share/icons/hicolor/icon-theme.cache"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk-doc-html=no"
