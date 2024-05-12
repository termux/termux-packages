TERMUX_PKG_HOMEPAGE=https://mate-desktop.org
TERMUX_PKG_DESCRIPTION="mate-menus contains the libmate-menu library, the layout configuration"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-menus/releases/download/v$TERMUX_PKG_VERSION/mate-menus-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=cf40c75c7d6f0aad1d4969828fc62025c6222bc6a84f0bb9d6ead7e45970508d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir
}
