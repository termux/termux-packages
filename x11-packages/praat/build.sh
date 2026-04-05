TERMUX_PKG_HOMEPAGE=https://www.praat.org
TERMUX_PKG_DESCRIPTION="Doing phonetics by computer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.63"
TERMUX_PKG_SRCURL=https://github.com/praat/praat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=63964641460e88e4fe0194497b2d149f446004628380a424e0491b46f0257d0a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libc++, libcairo, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	rm -f meson.build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin praat
}
