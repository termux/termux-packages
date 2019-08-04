TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer base plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.16.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4093aa7b51e28fb24dfd603893fead8d1b7782f088b05ed0f22a21ef176fb5ae
TERMUX_PKG_DEPENDS="gstreamer, libjpeg-turbo, libopus, libpng, libvorbis, zlib"
TERMUX_PKG_BREAKS="gst-plugins-base-dev"
TERMUX_PKG_REPLACES="gst-plugins-base-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
GLIB_GENMARSHAL=/usr/bin/glib-genmarshal
GLIB_MKENUMS=/usr/bin/glib-mkenums
--disable-tests
--disable-examples
--disable-pango
"

termux_step_post_make_install() {
	for BINARY in gst-play-1.0 gst-discoverer-1.0 gst-device-monitor-1.0
	    do
		echo $BINARY
		local LIBEXEC_BINARY=$TERMUX_PREFIX/libexec/$BINARY
		local BIN_BINARY=$TERMUX_PREFIX/bin/$BINARY
		local LIB_PATH=/system/lib
		local VENDOR_LIB_PATH=/system/vendor/lib
		if [ ! "$TERMUX_ARCH_BITS" == "32" ]
		then
			LIB_PATH+=64
			VENDOR_LIB_PATH+=64
		fi

		mv $BIN_BINARY $LIBEXEC_BINARY
		local FFMPEG_LIBS="" lib
	for lib in avcodec avfilter avformat avutil postproc swresample swscale; do
		if [ -n "$FFMPEG_LIBS" ]; then FFMPEG_LIBS+=":"; fi
		FFMPEG_LIBS+="$TERMUX_PREFIX/lib/lib${lib}.so"
	done

		cat << EOF > $BIN_BINARY
#!/bin/sh
export LD_PRELOAD=$FFMPEG_LIBS
# Avoid linker errors due to libOpenSLES.so:
LD_LIBRARY_PATH=$LIB_PATH:$VENDOR_LIB_PATH:$TERMUX_PREFIX/lib exec $LIBEXEC_BINARY "\$@"
EOF
		chmod +x $BIN_BINARY
	done
}
