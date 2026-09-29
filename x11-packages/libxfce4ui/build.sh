TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/libxfce4ui/start
TERMUX_PKG_DESCRIPTION="Commonly used XFCE widgets among XFCE applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/libxfce4ui/${TERMUX_PKG_VERSION%.*}/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=5d3d67b1244a10cee0e89b045766c05fe1035f7938f0410ac6a3d8222b5df907
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libepoxy, libgtop, libice, libsm, libx11, libxfce4util, pango, startup-notification, xfconf, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xfce4-dev-tools"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
# for some reason, TERMUX_PKG_BUILD_IN_SRC=true prevents this error:
# Libxfce4ui-2.0.gir:121.7-121.47: error: Xfce.FilenameInput:
# Classes cannot have multiple base classes (`Gtk.Box' and `Atk.Implementor')
# when --enable-vala=yes
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-vendor-info=Termux
--disable-debug
--disable-static
--enable-introspection=yes
--enable-epoxy
--enable-vala=yes
--enable-gladeui2=no
--enable-glibtop
--enable-gtk-doc-html=no
--enable-libsm
--enable-startup-notification
--enable-x11
--enable-wayland
"

termux_step_pre_configure() {
	termux_setup_gir
}
