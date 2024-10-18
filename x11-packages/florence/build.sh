TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/florence/
TERMUX_PKG_DESCRIPTION="A configurable on-screen virtual keyboard"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.3
TERMUX_PKG_REVISION=33
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/florence/files/florence/${TERMUX_PKG_VERSION}/florence-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=422992fd07d285be73cce721a203e22cee21320d69b0fda1579ce62944c5091e
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gstreamer, gtk3, libcairo, librsvg, libx11, libxext, libxml2, libxtst, pango"
TERMUX_PKG_MAKE_PROCESSES=1

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--without-notification
--without-at-spi
--with-panelapplet
--with-xtst
--without-docs
"

TERMUX_PKG_RM_AFTER_INSTALL="
lib/locale
"

termux_step_pre_configure() {
	export LIBS="-lglib-2.0 -lgio-2.0"
}
