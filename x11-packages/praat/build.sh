TERMUX_PKG_HOMEPAGE=https://www.praat.org
TERMUX_PKG_DESCRIPTION="Doing phonetics by computer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.0.03"
TERMUX_PKG_SRCURL=https://github.com/praat/praat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f193e8ba08bcc659d9291661c962508f342d272e7f7b4cd7bb417855d9bb249d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libc++, libcairo, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	rm -f meson.build
	sed -i 's/ -no-pie//g' Makefile
}

termux_step_pre_configure() {
	export PRAAT_AUDIO=pulseaudio
}

termux_step_make() {
	make AR="$AR" CC="$CC" CXX="$CXX" LINKER_COMMAND="$CXX"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin praat
}
