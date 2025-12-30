TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/libxfce4windowing/start
TERMUX_PKG_DESCRIPTION="Windowing concept abstraction library for X11 and Wayland"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.5"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/libxfce4windowing/${TERMUX_PKG_VERSION%.*}/libxfce4windowing-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6b4e19a66db650c9c8a88f00bbf266e9ced0070b7dbc0aaeea05be0fc6a2eb4d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libdisplay-info, libwayland, libwnck, libx11, libxrandr, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, libwayland-protocols, libwayland-cross-scanner, xfce4-dev-tools"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
--enable-introspection=yes
--enable-gtk-doc-html=no
--enable-wayland
--enable-x11
XDT_GEN_VISIBILITY=${TERMUX_PREFIX}/bin/xdt-gen-visibility
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_wayland_cross_pkg_config_wrapper
}
