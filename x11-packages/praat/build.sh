TERMUX_PKG_HOMEPAGE=https://www.praat.org
TERMUX_PKG_DESCRIPTION="Doing phonetics by computer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.3
TERMUX_PKG_SRCURL=https://github.com/praat/praat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d294c046ab07509a4c94851f7f9060089897b1fa90eaa335d84fd3e147e181e
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libc++, libcairo, pango, pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin praat
}
