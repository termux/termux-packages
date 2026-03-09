TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/ristretto/start
TERMUX_PKG_DESCRIPTION="The Ristretto Image Viewer is an application that can be used to view, and scroll through images."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/ristretto/${TERMUX_PKG_VERSION%.*}/ristretto-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=502cf1577de14b38132dc89e56884c5e10f86f6a028d8dde379a8839110fda55
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exo, file, gdk-pixbuf, glib, gtk3, libcairo, libexif, libx11, libxfce4ui, libxfce4util, pango, xfconf"
TERMUX_PKG_RECOMMENDS="tumbler"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
