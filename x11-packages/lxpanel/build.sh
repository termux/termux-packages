TERMUX_PKG_HOMEPAGE=https://github.com/lxde/lxpanel
TERMUX_PKG_DESCRIPTION="Lightweight X11 desktop panel for LXDE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="0.11.1"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxpanel/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=24334dde6ed37d32bb021f902dbd54a1e6cdd01f35a778d80fcd3acd23a0e93b
TERMUX_PKG_DEPENDS="alsa-lib, gdk-pixbuf, glib, gtk3, keybinder, libcairo, libcurl, libfm, libwnck, libx11, libxml2, lxhotkey, lxmenu-data, menu-cache, pango"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
# netstat plugin needs wireless_tools (iwlib.h), not available on Termux.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3 --with-plugins=all,-netstat"

termux_step_pre_configure() {
	./autogen.sh
}
