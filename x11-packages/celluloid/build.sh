TERMUX_PKG_HOMEPAGE="https://celluloid-player.github.io/"
TERMUX_PKG_DESCRIPTION="Simple GTK+ frontend for mpv"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.30"
TERMUX_PKG_SRCURL="https://github.com/celluloid-player/celluloid/releases/download/v${TERMUX_PKG_VERSION}/celluloid-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7fef96431842c24e5ae78a9c42bc6523818a6c45213f23ceb146d037d6ec8559
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk4, libadwaita, libepoxy, mpv-x"

termux_step_pre_configure() {
	# Workaround strict compiler error
	sed -i "s/-Werror/-Wno-error/g" meson.build

	termux_setup_glib_cross_pkg_config_wrapper
}
