TERMUX_PKG_HOMEPAGE=https://www.geany.org/
TERMUX_PKG_DESCRIPTION="Fast and lightweight IDE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.38
TERMUX_PKG_SRCURL=https://download.geany.org/geany-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=abff176e4d48bea35ee53037c49c82f90b6d4c23e69aed6e4a5ca8ccd3aad546
# libvte is dlopen(3)ed:
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-glob, libandroid-shmem, libc++, libcairo, libpixman, libpng, libvte, libx11, libxcb, libxext, libxrender, pango, zlib"
TERMUX_PKG_RECOMMENDS="clang, make"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3 --enable-vte"

TERMUX_PKG_RM_AFTER_INSTALL="
share/icons/hicolor/icon-theme.cache
share/icons/Tango/icon-theme.cache
"

termux_step_pre_configure() {
	export LIBS="-landroid-glob $($CC -print-libgcc-file-name)"
}
