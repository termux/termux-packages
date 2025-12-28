TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Good Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.26.10"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7beacb5daba3c6751ebc1c85017d9b1d6de64e24798125932c73c8b1dbeb3bc9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gst-plugins-base, gstreamer, libandroid-shmem, libbz2, libcaca, libflac, libjpeg-turbo, libmp3lame, libnettle, libpng, libvpx, libx11, libxext, libxfixes, libxml2, libmpg123, pulseaudio, zlib"
# -Dqt5=disabled and -Dqt6=disabled avoid
# /bin/bash: line 1: /data/data/com.termux/files/usr/lib/qt6/moc: cannot execute binary file: Exec format error
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dcairo=disabled
-Dexamples=disabled
-Dgdk-pixbuf=disabled
-Doss=disabled
-Doss4=disabled
-Dtests=disabled
-Dv4l2=disabled
-Daalib=disabled
-Dqt5=disabled
-Dqt6=disabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
	LDFLAGS+=" -landroid-shmem"
}
