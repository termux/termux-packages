TERMUX_PKG_HOMEPAGE=https://gitlab.xfce.org/apps/mousepad
TERMUX_PKG_DESCRIPTION="A simple text editor for the Xfce desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/mousepad/${TERMUX_PKG_VERSION%.*}/mousepad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e86c59feb08126d4cace368432c16b2dee8e519aaca8a9d2b409ae1cdd200802
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gspell, gtk3, gtksourceview4, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfconf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtksourceview4=enabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
