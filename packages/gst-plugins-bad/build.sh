TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Bad Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.26.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f8287a84c5f66368a5a50da5f969994a02c47f20220ffe1ca3154193e65af216
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
