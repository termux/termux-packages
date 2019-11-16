TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/vte/
TERMUX_PKG_DESCRIPTION="Virtual Terminal library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.58.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vte/${TERMUX_PKG_VERSION:0:4}/vte-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=33c966d2b1f2c3b0f9416dbca883fd746159b5bd040350e3b78f8104b2a42bc0
TERMUX_PKG_DEPENDS="gtk3, libgnutls, fribidi, pcre2"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dgir=false -Dvapi=false"

termux_step_pre_configure() {
	CXXFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX"
}
