TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/FileRoller
TERMUX_PKG_DESCRIPTION="File Roller is an archive manager for the GNOME desktop environment."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="44.5"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/file-roller/${TERMUX_PKG_VERSION%.*}/file-roller-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=dfaf4bb989c0b8986be8bdae9fffeab8d0f30669ae3a627e8c3df94f23888339
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk4, json-glib, libadwaita, libarchive, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_RECOMMENDS="arj, brotli, bsdtar, bzip2, cpio, file-roller-help, gzip, lz4, lzip, lzop, p7zip, tar, unrar, unzip, xz-utils, zip, zstd"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Duse_native_appchooser=false
-Dcpio=$TERMUX_PREFIX/bin/cpio
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
