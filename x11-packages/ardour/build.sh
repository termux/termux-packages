TERMUX_PKG_HOMEPAGE=https://ardour.org/
TERMUX_PKG_DESCRIPTION="A professional digital workstation for working with audio and MIDI"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.9"
TERMUX_PKG_SRCURL=git+https://github.com/Ardour/ardour
TERMUX_PKG_GIT_BRANCH="$TERMUX_PKG_VERSION"
TERMUX_PKG_DEPENDS="aubio, fftw, fontconfig, glib, libandroid-execinfo, libandroid-shmem, libarchive, libc++, libcairo, libcairomm-1.0, libcurl, libglibmm-2.4, libjpeg-turbo, liblo, liblrdf, libpangomm-1.4, libpng, libsamplerate, libsigc++-2.0, libsndfile, libusb, libwebsockets, libx11, libxext, libxml2, lilv, pango, pulseaudio, readline, rubberband, serd, suil, taglib, vamp-plugin-sdk"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
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
	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", ardour-data"

	LDFLAGS+=" -landroid-execinfo -landroid-shmem"
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

termux_step_post_make_install() {
	local lib
	for lib in "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}${TERMUX_PKG_VERSION%%.*}"/lib*.so.*.*; do
		ln -sf "$(basename "${lib}")" "${lib%.*.*}"
	done
}
