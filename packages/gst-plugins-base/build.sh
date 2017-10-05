TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer base plug-ins"
TERMUX_PKG_VERSION=1.12.3
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="gstreamer"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tests --disable-examples"
#TERMUX_PKG_SHA256=

termux_step_post_make_install () {
	for BINARY in gst-play-1.0 gst-discoverer-1.0 gst-device-monitor-1.0
	    do	
		echo $BINARY
		local LIBEXEC_BINARY=$TERMUX_PREFIX/libexec/$BINARY
		local BIN_BINARY=$TERMUX_PREFIX/bin/$BINARY
		local LIB_PATH=/system/lib
		if [ ! "$TERMUX_ARCH_BITS" == "32" ]
		then
			LIB_PATH+=64
		fi
			
		mv $BIN_BINARY $LIBEXEC_BINARY

		cat << EOF > $BIN_BINARY
#!/bin/sh

# Avoid linker errors due to libOpenSLES.so:
LD_LIBRARY_PATH=/system/lib64/:$TERMUX_PREFIX/lib exec $LIBEXEC_BINARY "\$@"
EOF
		chmod +x $BIN_BINARY
	done
}
