TERMUX_PKG_HOMEPAGE=https://mate-desktop.org
TERMUX_PKG_DESCRIPTION="mate-menus contains the libmate-menu library, the layout configuration"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.1"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-menus/releases/download/v$TERMUX_PKG_VERSION/mate-menus-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=d6a61d3bfbf58176fb52049f115d4e3a0d108fe5f1ef87438fafd86384e603d1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}
