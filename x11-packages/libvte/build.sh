TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/vte/
TERMUX_PKG_DESCRIPTION="Virtual Terminal library"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Do not update to 0.64.x or later with no caution; may break xfce4-terminal
_MAJOR_VERSION=0.62
_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_VERSION=2:${_VERSION}
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/vte/${_MAJOR_VERSION}/vte-${_VERSION}.tar.xz
TERMUX_PKG_SHA256=f5770285a52cc23a3c0428a43d492b7c0ba458ce7b8a73768a7d4f1e8a7db3b4
TERMUX_PKG_DEPENDS="atk, fribidi, gdk-pixbuf, gtk3, libc++, libcairo, libgnutls, libicu, pango, pcre2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgir=true
-Dvapi=false
"

termux_step_pre_configure() {
	termux_setup_gir

	CPPFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX"
}
