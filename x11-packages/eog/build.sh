TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/EyeOfGnome
TERMUX_PKG_DESCRIPTION="Eye of GNOME, an image viewing and cataloging program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="50.3"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/eog/${TERMUX_PKG_VERSION%.*}/eog-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=37280cd3874c6f219012b219f9f2c83bd88d750bf25f05bc7f742f41018466f4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gnome-desktop3, gobject-introspection, gsettings-desktop-schemas, gtk3, libcairo, libexif, libhandy, libjpeg-turbo, libpeas, librsvg, libx11, littlecms, shared-mime-info, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="eog-help"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dxmp=false
-Dintrospection=true
-Dlibportal=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
