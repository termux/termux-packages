TERMUX_PKG_HOMEPAGE=https://dopewars.sourceforge.io
TERMUX_PKG_DESCRIPTION="Drug-dealing game set in streets of New York City"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://prdownloads.sourceforge.net/dopewars/dopewars-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=83127903a61d81cda251a022f9df150d11e27bdd040e858c09c57927cc0edea6
TERMUX_PKG_DEPENDS="ncurses, glib, pcre, curl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-sdl
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gnome"
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	autoreconf -vfi
}
