TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer base plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.2"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4db76b3619280037a4047de7d9dbb38613a4272dcc40efb333257124635a888d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, graphene, gstreamer, libandroid-shmem, libjpeg-turbo, libogg, libopus, libpng, libtheora, libvorbis, libx11, libxcb, libxext, libxi, libxv, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, opengl"
TERMUX_PKG_RECOMMENDS="opengl"
TERMUX_PKG_BREAKS="gst-plugins-base-dev"
TERMUX_PKG_REPLACES="gst-plugins-base-dev"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false

# wrap-mode=nodownload prevents downloading gl-headers which conflicts with libglvnd-dev
# -Dgl_winsys=egl,surfaceless,x11,android (disabling wayland)
# prevents 'ld.lld: error: undefined symbol: gst_gl_display_wayland_get_type'
# if wayland libraries are present in $TERMUX_PREFIX before building gst-plugins-base
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dtests=disabled
-Dexamples=disabled
-Dpango=disabled
--wrap-mode=nodownload
-Dgl_winsys=egl,surfaceless,x11,android
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	LDFLAGS+=" -landroid-shmem"
}

termux_step_post_massage() {
	local dir="include/GL"
	if [[ -d "${TERMUX_PKG_MASSAGEDIR}${TERMUX_PREFIX}/$dir" ]]; then
		termux_error_exit "$dir should not exist in $TERMUX_PKG_NAME!"
	fi
}
