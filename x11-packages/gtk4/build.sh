TERMUX_PKG_HOMEPAGE=https://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.12.4"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtk/${TERMUX_PKG_VERSION%.*}/gtk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ba67c6498e5599f928edafb9e08a320adfaa50ab2f0da6fc6ab2252fc2d57520
TERMUX_PKG_DEPENDS="adwaita-icon-theme, fontconfig, fribidi, gdk-pixbuf, glib, glib-bin, graphene, gtk-update-icon-cache, harfbuzz, libcairo, libepoxy, libjpeg-turbo, libpng, libtiff, libwayland, libx11, libxcursor, libxdamage, libxext, libxfixes, libxi, libxinerama, libxkbcommon, libxrandr, pango, shared-mime-info"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, libwayland-protocols, xorgproto"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, librsvg, ttf-dejavu"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-demos=false
-Dbuild-examples=false
-Dbuild-tests=false
-Dbuild-testsuite=false
-Dintrospection=enabled
-Dmedia-gstreamer=disabled
-Dprint-cups=disabled
-Dvulkan=disabled
-Dwayland-backend=true
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_gir
	termux_setup_ninja

	local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper/bin"
	mkdir -p "${_WRAPPER_BIN}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		sed \
			-e "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			-e "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/libwayland/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${_WRAPPER_BIN}/pkg-config"
		chmod +x "${_WRAPPER_BIN}/pkg-config"
		export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	fi
	export PATH="${_WRAPPER_BIN}:${PATH}"
}
