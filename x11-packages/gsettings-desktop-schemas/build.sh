TERMUX_PKG_HOMEPAGE=https://www.gnome.org/
TERMUX_PKG_DESCRIPTION="GNOME desktop schemas contains a collection of GSettings schemas for settings shared by various components of a desktop."
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
_MAJOR_VERSION=43
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gsettings-desktop-schemas/${_MAJOR_VERSION}/gsettings-desktop-schemas-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5d5568282ab38b95759d425401f7476e56f8cbf2629885587439f43bd0b84bbe
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
