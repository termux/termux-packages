TERMUX_PKG_HOMEPAGE=https://gitlab.xfce.org/apps/mousepad
TERMUX_PKG_DESCRIPTION="A simple text editor for the Xfce desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.5
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.9
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/mousepad/${_MAJOR_VERSION}/mousepad-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f108a8c167ec5727266ab67666f10dbd60e972d56ea03944302fdabb2167f473
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, glib, gtk3, gtksourceview4, harfbuzz, libcairo, libpixman, libpng, libx11, libxcb, libxext, libxrender, pango, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtksourceview4
"
