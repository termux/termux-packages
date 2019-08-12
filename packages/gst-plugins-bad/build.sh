TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Bad Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.16.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=22139de35626ada6090bdfa3423b27b7fc15a0198331d25c95e6b12cb1072b05
TERMUX_PKG_DEPENDS="gst-plugins-base, libbz2, libcurl, libiconv, libpng, librsvg, libssh2, libsndfile, libx264, libx265, littlecms, openal-soft, openjpeg"
TERMUX_PKG_BREAKS="gst-plugins-bad-dev"
TERMUX_PKG_REPLACES="gst-plugins-bad-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-android_media
--disable-examples
--disable-rtmp
--disable-tests
--disable-zbar
--disable-webp
--with-hls-crypto=openssl
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/"

termux_step_pre_configure() {
	export GNUSTL_LIBS="-lc"
	export GNUSTL_CFLAGS="-Oz"
	export GLIB_MKENUMS="/usr/bin/glib-mkenums"
}
