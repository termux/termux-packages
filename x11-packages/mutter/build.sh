TERMUX_PKG_HOMEPAGE=https://mutter.gnome.org/
TERMUX_PKG_DESCRIPTION="A Wayland display server and X11 window manager and compositor library"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.3"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/mutter/${TERMUX_PKG_VERSION%%.*}/mutter-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=9ef1f61d6fe401cca3fcbe6d9a3b2a4f9b42638cbf8443735666a61964a8f0c3
TERMUX_PKG_DEPENDS="atk, fribidi, gdk-pixbuf, glib, gnome-desktop4, gobject-introspection, graphene, gsettings-desktop-schemas, gtk4, harfbuzz, libandroid-shmem, libcairo, libcanberra, libcolord, libdisplay-info, libdrm, libei, libice, libpixman, libsm, libwayland, libx11, libxau, libxcb, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxinerama, libxkbcommon, libxkbfile, libxrandr, libxtst, littlecms, opengl, pango, pipewire, startup-notification, xkeyboard-config, xwayland"
TERMUX_PKG_BUILD_DEPENDS="glib-cross, libwayland-protocols"
TERMUX_PKG_VERSIONED_GIR=false

# TODO: Add libwacom
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlogind=false
-Dudev=false
-Dnative_backend=false
-Dlibwacom=false
-Dintrospection=true
-Dtests=disabled
-Dinstalled_tests=false
-Dbash_completion=false
-Dprofiler=false
-Dx11=true
-Dxwayland_path=$TERMUX_PREFIX/bin/Xwayland
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_pkg_config_wrapper "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:${TERMUX_PREFIX}/opt/libwayland/cross/lib/x86_64-linux-gnu/pkgconfig"


	export TERMUX_MESON_ENABLE_SOVERSION=1
	LDFLAGS+=" -landroid-shmem"
}
