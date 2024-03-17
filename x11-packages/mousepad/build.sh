TERMUX_PKG_HOMEPAGE=https://gitlab.xfce.org/apps/mousepad
TERMUX_PKG_DESCRIPTION="A simple text editor for the Xfce desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/mousepad/${TERMUX_PKG_VERSION%.*}/mousepad-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e7cacb3b8cb1cd689e6341484691069e73032810ca51fc747536fc36eb18d19d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, gtksourceview4, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfconf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtksourceview4
"
