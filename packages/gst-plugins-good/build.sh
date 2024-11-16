TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Good Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.9"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=897de50bff337e3ca2f86f1eaa28e0828d83024156162a50c4ea0af86e29799f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gst-plugins-base, gstreamer, libandroid-shmem, libbz2, libcaca, libflac, libjpeg-turbo, libmp3lame, libnettle, libpng, libvpx, libx11, libxext, libxfixes, libxml2, mpg123, pulseaudio, zlib"
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
