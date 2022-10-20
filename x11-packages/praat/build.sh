TERMUX_PKG_HOMEPAGE=https://www.praat.org
TERMUX_PKG_DESCRIPTION="Doing phonetics by computer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.2.23
TERMUX_PKG_SRCURL=https://github.com/praat/praat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cc2041656a9d8b36a7dd5115ddde2af09d669c6179d252330b83da9504483b62
TERMUX_PKG_DEPENDS="gtk3, pulseaudio, xorgproto"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin praat
}
