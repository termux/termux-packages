TERMUX_PKG_HOMEPAGE=https://dopewars.sourceforge.io
TERMUX_PKG_DESCRIPTION="Drug-dealing game set in streets of New York City"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_SRCURL=https://prdownloads.sourceforge.net/dopewars/dopewars-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=106dfea6a019b00b69a26044c82d6977296c0c7c684c0c9c256a04ed8adfb20f
TERMUX_PKG_DEPENDS="glib, libcurl, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-sdl
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gnome"
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	autoreconf -vfi
}
