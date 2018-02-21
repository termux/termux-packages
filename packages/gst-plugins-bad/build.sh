TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Bad Plug-ins"
TERMUX_PKG_VERSION=1.12.4
TERMUX_PKG_SHA256=0c7857be16686d5c1ba6e34bd338664d3d4599d32714a8eca5c8a41a101e2d08
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base, libmp3lame, libx264, libbz2, libpng, librsvg, libcurl, libx265, libsndfile, openjpeg, openal-soft"
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
