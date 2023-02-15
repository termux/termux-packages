TERMUX_PKG_HOMEPAGE=https://ardour.org/
TERMUX_PKG_DESCRIPTION="A professional digital workstation for working with audio and MIDI"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.3
TERMUX_PKG_SRCURL=git+https://github.com/Ardour/ardour
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="aubio, fftw, fontconfig, glib, gtk2, gtkmm2, libandroid-execinfo, libarchive, libatkmm-1.6, libc++, libcairo, libcairomm-1.0, libcurl, libglibmm-2.4, liblo, liblrdf, libpangomm-1.4, libsamplerate, libsigc++-2.0, libsndfile, libusb, libwebsockets, libx11, libxml2, lilv, pango, pulseaudio, rubberband, taglib, vamp-plugin-sdk"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-backends=dummy,pulseaudio
--no-fpu-optimization
--freedesktop
--no-nls
--no-phone-home
--noconfirm
--optimize
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}

termux_step_configure() {
	./waf configure \
		--prefix=$TERMUX_PREFIX \
		LINKFLAGS="$LDFLAGS" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make() {
	./waf
}

termux_step_make_install() {
	./waf install
}
