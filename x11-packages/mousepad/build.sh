TERMUX_PKG_HOMEPAGE=https://gitlab.xfce.org/apps/mousepad
TERMUX_PKG_DESCRIPTION="A simple text editor for the Xfce desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.4"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/mousepad/${TERMUX_PKG_VERSION%.*}/mousepad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0aeb848e76a9a1e4186a5055328bbffdfdfae1b231db04b836b1816771c0db46
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gspell, gtk3, gtksourceview4, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfconf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtksourceview4=enabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
