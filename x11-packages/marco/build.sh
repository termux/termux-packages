TERMUX_PKG_HOMEPAGE=https://marco.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="MATE default window manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29.0"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/marco/releases/download/v$TERMUX_PKG_VERSION/marco-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=54aa87fe49b904b6911d7b81081eaea524eeb75b158b2558b84e33ef0315fc54
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libcairo, libcanberra, libice, libsm, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxinerama, libxpresent, libxrandr, libxrender, libxres, mate-desktop, pango, startup-notification, zenity"

termux_step_pre_configure() {
	# Workaround: make compiler warning non-fatal
	sed -i "s/-Werror=/-Wno-error=/g" meson.build

	termux_setup_glib_cross_pkg_config_wrapper
}
