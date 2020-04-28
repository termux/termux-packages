TERMUX_PKG_HOMEPAGE=https://dopewars.sourceforge.io
TERMUX_PKG_DESCRIPTION="Drug-dealing game set in streets of New York City"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.5.12
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://prdownloads.sourceforge.net/dopewars/dopewars-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=23059dcdea96c6072b148ee21d76237ef3535e5be90b3b2d8239d150feee0c19
TERMUX_PKG_DEPENDS="ncurses, glib, pcre"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-sdl
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gnome"
