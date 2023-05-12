TERMUX_PKG_HOMEPAGE=https://launchpad.net/libdbusmenu
TERMUX_PKG_DESCRIPTION="A small library designed to make sharing and displaying of menu structures over DBus"
TERMUX_PKG_LICENSE="LGPL-2.1, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=16.04
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://launchpad.net/libdbusmenu/${_MAJOR_VERSION}/${TERMUX_PKG_VERSION}/+download/libdbusmenu-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b9cc4a2acd74509435892823607d966d424bd9ad5d0b00938f27240a1bfa878a
TERMUX_PKG_DEPENDS="glib, json-glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-dumper
--enable-introspection=yes
--enable-vala=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}
