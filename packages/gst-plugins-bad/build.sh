TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Bad Plug-ins"
TERMUX_PKG_VERSION=1.14.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=2a77c6908032aafdf2cd2e5823fec948f16a25c2d1497a953828d762dc20d61a
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base, libx264, libbz2, libpng, librsvg, libcurl, libx265, libsndfile, openjpeg, openal-soft, littlecms"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--disable-examples
--disable-android_media
--disable-zbar
--with-hls-crypto=openssl
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/"

termux_step_pre_configure() {
	export GNUSTL_LIBS="-lc"
	export GNUSTL_CFLAGS="-Oz"
}
