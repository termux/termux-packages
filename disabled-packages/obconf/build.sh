TERMUX_PKG_HOMEPAGE=http://openbox.org/wiki/ObConf:About
TERMUX_PKG_DESCRIPTION="A configuration tool for the Openbox window manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.4
TERMUX_PKG_REVISION=30
TERMUX_PKG_SRCURL=http://openbox.org/dist/obconf/obconf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=71a3e5f4ee246a27421ba85044f09d449f8de22680944ece9c471cd46a9356b9
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk2, libglade, libx11, libxml2, openbox, startup-notification"

termux_step_pre_configure() {
	export LIBS="-lgmodule-2.0"
}
