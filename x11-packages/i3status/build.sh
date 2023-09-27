TERMUX_PKG_HOMEPAGE=https://i3wm.org/i3status/
TERMUX_PKG_DESCRIPTION="Generates status bar to use with i3bar"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14
TERMUX_PKG_SRCURL=https://i3wm.org/i3status/i3status-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5c4d0273410f9fa3301fd32065deda32e9617fcae8b3cb34793061bf21644924
TERMUX_PKG_DEPENDS="libandroid-glob, libconfuse, libnl, pulseaudio, yajl"
TERMUX_PKG_CONFFILES="etc/i3status.conf"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
