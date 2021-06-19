TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/vte/
TERMUX_PKG_DESCRIPTION="Virtual Terminal library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1:0.62.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vte/${TERMUX_PKG_VERSION:2:4}/vte-${TERMUX_PKG_VERSION:2}.tar.xz
TERMUX_PKG_SHA256=b0300bbcf0c02df5812a10a3cb8e4fff723bab92c08c97a0a90c167cf543aff0
TERMUX_PKG_DEPENDS="fribidi, gtk3, libgnutls, libicu, pcre2"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dgir=false -Dvapi=false"

termux_step_pre_configure() {
	CXXFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX"
}
