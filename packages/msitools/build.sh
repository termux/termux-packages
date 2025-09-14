TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/msitools
TERMUX_PKG_DESCRIPTION="Set of programs to inspect and build Windows Installer (.MSI) files"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.106"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/msitools/${TERMUX_PKG_VERSION}/msitools-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1ed34279cf8080f14f1b8f10e649474125492a089912e7ca70e59dfa2e5a659b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gcab, glib, libgsf, libxml2"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
