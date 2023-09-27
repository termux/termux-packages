TERMUX_PKG_HOMEPAGE=https://mate-menus.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-menus contains the libmate-menu library, the layout configuration"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.26.1
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-menus/releases/download/v$TERMUX_PKG_VERSION/mate-menus-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=458d599ae5b650c7d21740f9fe954c4a838be45ed62ab40e20e306faf5dd1d8c
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}
