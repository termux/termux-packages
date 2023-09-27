TERMUX_PKG_HOMEPAGE=https://dopewars.sourceforge.io
TERMUX_PKG_DESCRIPTION="Drug-dealing game set in streets of New York City"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.2
TERMUX_PKG_SRCURL=https://prdownloads.sourceforge.net/dopewars/dopewars-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=623b9d1d4d576f8b1155150975308861c4ec23a78f9cc2b24913b022764eaae1
TERMUX_PKG_DEPENDS="glib, libcurl, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-sdl
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gnome"
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	autoreconf -vfi
}
