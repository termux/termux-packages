TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/libxfce4ui/start
TERMUX_PKG_DESCRIPTION="Commonly used XFCE widgets among XFCE applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/libxfce4ui/${TERMUX_PKG_VERSION%.*}/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=75e8996984f20375aadecd5c16f5147c211ed0bd26d7861ab0257561eb76eaee
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libepoxy, libgtop, libice, libsm, libx11, libxfce4util, pango, startup-notification, xfconf, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xfce4-dev-tools"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-vendor-info=Termux
--disable-debug
--enable-introspection=yes
--enable-epoxy
--enable-vala=no
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
