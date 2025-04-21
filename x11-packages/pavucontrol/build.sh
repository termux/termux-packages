TERMUX_PKG_HOMEPAGE=https://freedesktop.org/software/pulseaudio/pavucontrol/
TERMUX_PKG_DESCRIPTION="PulseAudio Volume Control"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/pulseaudio/pavucontrol/-/archive/v$TERMUX_PKG_VERSION/pavucontrol-v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fd4a571191ea7d08670db75137920698c7ce6ce9c94e808d28a5d76db11b7019
TERMUX_PKG_DEPENDS="glib, gtk4, gtkmm4, json-glib, libcanberra, libsigc++-3.0, pulseaudio, pulseaudio-glib"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
