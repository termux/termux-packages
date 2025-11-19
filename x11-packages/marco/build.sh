TERMUX_PKG_HOMEPAGE=https://marco.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="MATE default window manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29.1"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/marco/releases/download/v$TERMUX_PKG_VERSION/marco-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=94066fff18837179a08b3400960bb80602d912363c134743d3c24f802ab940ed
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libcairo, libcanberra, libice, libsm, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxinerama, libxpresent, libxrandr, libxrender, libxres, mate-desktop, pango, startup-notification, zenity"

termux_step_pre_configure() {
	# force meson
	rm configure

	# Workaround: make compiler warning non-fatal
	sed -i "s/-Werror=/-Wno-error=/g" meson.build

	termux_setup_glib_cross_pkg_config_wrapper
}
