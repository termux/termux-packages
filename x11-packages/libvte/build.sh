TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/vte/
TERMUX_PKG_DESCRIPTION="Virtual Terminal library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.64.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vte/${TERMUX_PKG_VERSION:0:4}/vte-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c0c60b8dc343167437c86d984b0cf134df86034180ed70513f683006ada3ec41
TERMUX_PKG_DEPENDS="fribidi, gtk3, libgnutls, libicu, pcre2"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dgir=false -Dvapi=false"

termux_step_pre_configure() {
	CXXFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX"
}
