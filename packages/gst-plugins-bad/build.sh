TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Bad Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.2"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6467e3964828f4d7d08bfe1fbb4d76287a1c8fa76674e59e101a149c020fefd7
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

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
