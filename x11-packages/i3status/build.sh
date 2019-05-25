TERMUX_PKG_HOMEPAGE=https://i3wm.org/i3status/
TERMUX_PKG_DESCRIPTION="Generates status bar to use with i3bar"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.12
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://i3wm.org/i3status/i3status-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6fc6881536043391ab4bed369d956f99d1088965d8bcebed18d1932de3ba791a
TERMUX_PKG_DEPENDS="libandroid-glob, libconfuse, libnl, libpulseaudio, yajl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/i3status.conf"

termux_step_pre_configure() {
	## Not working on Android
	rm -f src/print_battery_info.c

	## No ALSA available in Termux
	rm -f src/print_volume.c

	## 1. getloadavg() is not available on Android
	## 2. /proc/loadavg is not accessible on Android 8.0 (Oreo)
	rm -f src/print_load.c
}
