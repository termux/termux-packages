TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfce4-panel/start
TERMUX_PKG_DESCRIPTION="Panel for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-panel/${TERMUX_PKG_VERSION%.*}/xfce4-panel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e418e3b884a77a6ac76c0423442dbf866b1900665fefde486f27cdbb87087694
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, exo, garcon, gdk-pixbuf, glib, gtk3, gtk-layer-shell, harfbuzz, libcairo, libdisplay-info, libice, libsm, libwayland, libwnck, libx11, libxext, libxrandr, libxfce4ui, libxfce4util, libxfce4windowing, pango, xfconf, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xfce4-dev-tools"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, hicolor-icon-theme"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
# for some reason, TERMUX_PKG_BUILD_IN_SRC=true prevents this error:
# Libxfce4ui-2.0.gir:121.7-121.47: error: Xfce.FilenameInput:
# Classes cannot have multiple base classes (`Gtk.Box' and `Atk.Implementor')
# when --enable-vala=yes
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
--enable-gtk-doc-html=no
--enable-gtk-layer-shell
--enable-introspection=yes
--enable-vala=yes
--enable-wayland
--enable-x11
--disable-dbusmenu-gtk3
XDT_GEN_VISIBILITY=${TERMUX_PREFIX}/bin/xdt-gen-visibility
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	autoreconf -fiv

	# ERROR: ./lib/xfce4/panel/plugins/libsystray.so contains undefined symbols: ceil
	LDFLAGS+=" -lm"
}
