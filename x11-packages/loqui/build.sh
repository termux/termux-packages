TERMUX_PKG_HOMEPAGE=https://github.com/sunnyone/loqui
TERMUX_PKG_DESCRIPTION="IRC client for Gtk environment"
TERMUX_PKG_LICENSE="LGPL-2.0, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/sunnyone/loqui/releases/download/${TERMUX_PKG_VERSION}/loqui-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c593211d6bb477d5477ec9b81143e3faf96e859ad2edaf527fbc370333e5e0e7
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, pango"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
GLIB_GENMARSHAL=glib-genmarshal
--disable-glibtestr
--disable-gtktest
"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-error=return-type"
}
