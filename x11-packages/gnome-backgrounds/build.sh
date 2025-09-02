TERMUX_PKG_HOMEPAGE=https://github.com/GNOME/gnome-backgrounds
TERMUX_PKG_DESCRIPTION="A collection of GNOME desktop wallpapers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=48.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/GNOME/gnome-backgrounds/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=33523d10fded9b32776710db3bdfe8120b02d2836c321e229285d7e716e0da3a
TERMUX_PKG_AUTO_UPDATE=false

termux_step_pre_configure() {
	termux_setup_meson
}
