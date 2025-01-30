TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Bad Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.12"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3d386af3d1dbd1a06c74a6251250c269b481e703f0e3255ba89ef6c1e063afea
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="game-music-emu, glib, gst-plugins-base, gstreamer, libaom, libass, libbz2, libcairo, libcurl, libopus, librsvg, libsndfile, libsrt, libx11, libxml2, littlecms, openal-soft, openh264, openjpeg, openssl, pango"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_BREAKS="gst-plugins-bad-dev"
TERMUX_PKG_REPLACES="gst-plugins-bad-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dandroidmedia=disabled
-Dexamples=disabled
-Drtmp=disabled
-Dshm=disabled
-Dtests=disabled
-Dzbar=disabled
-Dwebp=disabled
-Dvulkan=disabled
-Dhls-crypto=openssl
"

termux_step_configure() {
	termux_setup_meson
	sed -i "2i glib-mkenums = '${TERMUX_PREFIX}/opt/glib/cross/bin/glib-mkenums'" $TERMUX_MESON_CROSSFILE

	local _meson_buildtype="minsize"
	local _meson_stripflag="--strip"
	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		_meson_buildtype="debug"
		_meson_stripflag=
	fi

	CC=gcc CXX=g++ CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= $TERMUX_MESON \
		$TERMUX_PKG_SRCDIR \
		$TERMUX_PKG_BUILDDIR \
		--cross-file $TERMUX_MESON_CROSSFILE \
		--prefix $TERMUX_PREFIX \
		--libdir lib \
		--buildtype ${_meson_buildtype} \
		${_meson_stripflag} \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS \
		|| (termux_step_configure_meson_failure_hook && false)
}
