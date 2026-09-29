TERMUX_PKG_HOMEPAGE=https://freedesktop.org/software/pulseaudio/pavucontrol/
TERMUX_PKG_DESCRIPTION="PulseAudio Volume Control"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.2"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/pulseaudio/pavucontrol/-/archive/v$TERMUX_PKG_VERSION/pavucontrol-v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e3677926f1eec42e24dd14ac5208e8ad557a807c3c18b1cd6c5faea531e840de
TERMUX_PKG_DEPENDS="glib, gtk4, gtkmm4, json-glib, libcanberra, libsigc++-3.0, pulseaudio, pulseaudio-glib"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
