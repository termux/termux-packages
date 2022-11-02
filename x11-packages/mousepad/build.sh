TERMUX_PKG_HOMEPAGE=https://gitlab.xfce.org/apps/mousepad
TERMUX_PKG_DESCRIPTION="A simple text editor for the Xfce desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.5
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.10
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/mousepad/${_MAJOR_VERSION}/mousepad-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6ebaf38d52bee5560d9650c52a693f8a6ed0a67d88cc938d73f7d5ce13552bad
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, gtksourceview4, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtksourceview4
"
