TERMUX_PKG_HOMEPAGE=https://gitlab.xfce.org/apps/mousepad
TERMUX_PKG_DESCRIPTION="A simple text editor for the Xfce desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.3"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/mousepad/${TERMUX_PKG_VERSION%.*}/mousepad-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2ff162c185f18014ab9c82c2ac2dfce4fba20eb0005e7690ee27f00b9cb929b9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gspell, gtk3, gtksourceview4, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfconf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtksourceview4
"
