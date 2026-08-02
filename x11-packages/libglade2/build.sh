TERMUX_PKG_HOMEPAGE="https://download.gnome.org/sources/libglade/"
TERMUX_PKG_DESCRIPTION="Library to load .glade files at runtime"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="2.6.4"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/libglade/${TERMUX_PKG_VERSION%.*}/libglade-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c41d189b68457976069073e48d6c14c183075d8b1d8077cb6dfb8b7c5097add3
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="atk, glib, gtk2, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"

termux_step_pre_configure() {
		LDFLAGS+=" -lgmodule-2.0"
}
