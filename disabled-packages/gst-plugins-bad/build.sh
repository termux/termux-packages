TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Bad Plug-ins"
TERMUX_PKG_VERSION=1.8.3
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tests --disable-examples"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-android_media"

termux_step_pre_configure () {
	# Missing file - bug in the the source distribution?
	# Reported at https://bugzilla.gnome.org/show_bug.cgi?id=770326
	# and scheduled to be fixed in 1.9.2 (note that 1.9 is an unstable
	# series).
	termux_download https://raw.githubusercontent.com/GStreamer/gst-plugins-bad/master/sys/opensles/opensles.h \
		        $TERMUX_PKG_SRCDIR/sys/opensles/opensles.h
}
