TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer base plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.26.2"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f4b9fc0be852fe5f65401d18ae6218e4aea3ff7a3c9f8d265939b9c4704915f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, graphene, gstreamer, libandroid-shmem, libjpeg-turbo, libogg, libopus, libpng, libtheora, libvorbis, libx11, libxcb, libxext, libxi, libxv, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, opengl"
TERMUX_PKG_RECOMMENDS="opengl"
TERMUX_PKG_BREAKS="gst-plugins-base-dev"
TERMUX_PKG_REPLACES="gst-plugins-base-dev"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dtests=disabled
-Dexamples=disabled
-Dpango=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	LDFLAGS+=" -landroid-shmem"
}
