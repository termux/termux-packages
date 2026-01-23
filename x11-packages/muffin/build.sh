TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/muffin
TERMUX_PKG_DESCRIPTION="The window management library for the Cinnamon desktop"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.2"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/muffin/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e5945463b8de26dcee79fb116f31effb8c499235c22c3a33bce57c2163c27cfe
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="atk, fribidi, gdk-pixbuf, glib, gnome-desktop4, gobject-introspection, graphene, gsettings-desktop-schemas, gtk4, harfbuzz, libandroid-shmem, libcairo, libcanberra, libcolord, libdisplay-info, libdrm, libei, libice, libpixman, libsm, libwayland, libx11, libxau, libxcb, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxinerama, libxkbcommon, libxkbfile, libxrandr, libxtst, littlecms, opengl, pango, pipewire, startup-notification, xkeyboard-config, xwayland, upower, cinnamon-desktop, json-glib, cogl, clutter, clutter-gtk"
TERMUX_PKG_BUILD_DEPENDS="glib-cross, libwayland-protocols"
TERMUX_PKG_VERSIONED_GIR=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dudev=false
-Dnative_backend=false
-Dremote_desktop=false
-Dlibwacom=false
-Dintrospection=true
-Dtests=false
-Dcore_tests=false
-Dinstalled_tests=false
-Dprofiler=false
-Dxwayland_path=$TERMUX_PREFIX/bin/Xwayland
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
	LDFLAGS+=" -landroid-shmem"
}
