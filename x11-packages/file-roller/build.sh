TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/FileRoller
TERMUX_PKG_DESCRIPTION="File Roller is an archive manager for the GNOME desktop environment."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
_MAJOR_VERSION=43
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/file-roller/${_MAJOR_VERSION}/file-roller-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=298729fdbdb9da8132c0bbc60907517d65685b05618ae05167335e6484f573a1
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, json-glib, libarchive, libcairo, libhandy, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="arj, brotli, bsdtar, bzip2, cpio, gzip, lz4, lzip, lzop, p7zip, tar, unrar, unzip, xz-utils, zip, zstd"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Duse_native_appchooser=false
-Dcpio=$TERMUX_PREFIX/bin/cpio
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir
}
