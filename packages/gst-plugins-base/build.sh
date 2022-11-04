TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer base plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.20.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7e30b3dd81a70380ff7554f998471d6996ff76bbe6fc5447096f851e24473c9f
TERMUX_PKG_DEPENDS="glib, gstreamer, libandroid-shmem, libogg, libopus, libtheora, libvorbis, libx11, libxext, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="gst-plugins-base-dev"
TERMUX_PKG_REPLACES="gst-plugins-base-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgl=disabled
-Dintrospection=enabled
-Dtests=disabled
-Dexamples=disabled
-Dpango=disabled
"

termux_step_pre_configure() {
	termux_setup_gir

	LDFLAGS+=" -landroid-shmem"
}

termux_step_post_massage() {
	# These files are pulled in when OpenGL support is enabled, and
	# conflict with `mesa` and `graphene` respectively.
	local _CONFLICTING_FILES="include/GL/glext.h lib/libgraphene-1.0.so"
	local f
	for f in ${_CONFLICTING_FILES}; do
		if [ -e "${f}" ]; then
			termux_error_exit "File ${f} should not be contained in this package."
		fi
	done
}
