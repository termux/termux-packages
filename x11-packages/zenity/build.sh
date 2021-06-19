TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/zenity
TERMUX_PKG_DESCRIPTION="a rewrite of gdialog, the GNOME port of dialog"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.32.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/zenity/${TERMUX_PKG_VERSION:0:4}/zenity-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=e786e733569c97372c3ef1776e71be7e7599ebe87e11e8ad67dcc2e63a82cd95
TERMUX_PKG_DEPENDS="glib, gtk3"
termux_step_pre_configure() {
	autoreconf -fi
}
