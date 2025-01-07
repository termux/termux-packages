TERMUX_PKG_HOMEPAGE=https://www.geany.org/
TERMUX_PKG_DESCRIPTION="Fast and lightweight IDE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0"
TERMUX_PKG_SRCURL=https://download.geany.org/geany-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=565b4cd2f0311c1e3a167ec71c4a32dba642e0fe554ae5bb6b8177b7a74ccc92
TERMUX_PKG_AUTO_UPDATE=true
# libvte is dlopen(3)ed:
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-glob, libc++, libcairo, libvte, pango"
TERMUX_PKG_RECOMMENDS="clang, make"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3 --enable-vte"

TERMUX_PKG_RM_AFTER_INSTALL="
share/icons/Tango/icon-theme.cache
"

termux_step_pre_configure() {
	export LIBS="-landroid-glob $($CC -print-libgcc-file-name)"
}
