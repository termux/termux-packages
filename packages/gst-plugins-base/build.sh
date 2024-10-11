TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer base plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.8"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=10fb31743750ccd498d3933e8aaecda563ebc65596a6ab875b47ee936e4b9599
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, graphene, gstreamer, libandroid-shmem, libjpeg-turbo, libogg, libopus, libpng, libtheora, libvorbis, libx11, libxcb, libxext, libxv, zlib"
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

	local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper/bin"
	mkdir -p "${_WRAPPER_BIN}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		sed "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${_WRAPPER_BIN}/pkg-config"
		chmod +x "${_WRAPPER_BIN}/pkg-config"
		export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	fi
	export PATH="${_WRAPPER_BIN}:${PATH}"

	LDFLAGS+=" -landroid-shmem"
}
