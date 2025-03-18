TERMUX_PKG_HOMEPAGE=https://www.gnome.org/
TERMUX_PKG_DESCRIPTION="GNOME desktop schemas contains a collection of GSettings schemas for settings shared by various components of a desktop."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="48.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gsettings-desktop-schemas/${TERMUX_PKG_VERSION%.*}/gsettings-desktop-schemas-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e68f155813bf18f865a8b2c8e9d473588b6ccadcafbb666ab788857c6c2d1bd3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RECOMMENDS="dconf"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	termux_setup_gir
}
