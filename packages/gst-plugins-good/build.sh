TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Good Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.26.6"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d0956535c8315856df9ca2de495f7725128b462863b3c7cd357ef64fb4199679
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gst-plugins-base, gstreamer, libandroid-shmem, libbz2, libcaca, libflac, libjpeg-turbo, libmp3lame, libnettle, libpng, libvpx, libx11, libxext, libxfixes, libxml2, libmpg123, pulseaudio, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dcairo=disabled
-Dexamples=disabled
-Dgdk-pixbuf=disabled
-Doss=disabled
-Doss4=disabled
-Dtests=disabled
-Dv4l2=disabled
-Daalib=disabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
	LDFLAGS+=" -landroid-shmem"
}
