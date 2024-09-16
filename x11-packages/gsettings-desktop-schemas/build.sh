TERMUX_PKG_HOMEPAGE=https://www.gnome.org/
TERMUX_PKG_DESCRIPTION="GNOME desktop schemas contains a collection of GSettings schemas for settings shared by various components of a desktop."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="47"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gsettings-desktop-schemas/${TERMUX_PKG_VERSION%.*}/gsettings-desktop-schemas-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7db042be5ed9c2e12e903f5362c7981518d65d9f548165777621fb199e996a27
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
