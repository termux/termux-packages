TERMUX_PKG_HOMEPAGE=https://i3wm.org/i3status/
TERMUX_PKG_DESCRIPTION="Generates status bar to use with i3bar"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.15"
TERMUX_PKG_SRCURL=https://i3wm.org/i3status/i3status-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6c67f52cae4f139df764ad1cc736562be0f97750791bc212b53f34c06eaf2205
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, libconfuse, libnl, pulseaudio, yajl"
TERMUX_PKG_CONFFILES="etc/i3status.conf"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
