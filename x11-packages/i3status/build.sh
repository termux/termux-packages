TERMUX_PKG_HOMEPAGE=https://i3wm.org/i3status/
TERMUX_PKG_DESCRIPTION="Generates status bar to use with i3bar"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.13
TERMUX_PKG_REVISION=22
TERMUX_PKG_SRCURL=https://i3wm.org/i3status/i3status-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ce89c9ff8565f62e88299f1a611229afdfc356b4e97368a5f8c4f06ad2fa1466
TERMUX_PKG_DEPENDS="libandroid-glob, libconfuse, libnl, pulseaudio, yajl"
TERMUX_PKG_CONFFILES="etc/i3status.conf"

termux_step_pre_configure() {
	autoreconf -fi
}
