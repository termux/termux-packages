TERMUX_PKG_HOMEPAGE=http://www.gnumeric.org/
TERMUX_PKG_DESCRIPTION="The GNOME spreadsheet"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.12
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.52
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnumeric/${_MAJOR_VERSION}/gnumeric-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=73cf73049a22a1d828506275b2c9378ec37c5ff37b68bb1f2f494f0d6400823b
TERMUX_PKG_DEPENDS="glib, goffice, gtk3, libcairo, libgsf, libxml2, pango, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=no
--without-gda
--without-psiconv
--without-paradox
--without-long-double
--without-perl
--without-python
"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU"
}

termux_step_post_configure() {
	local ver=$(awk '/^PACKAGE_VERSION =/ { print $3 }' Makefile)
	local so=$TERMUX_PREFIX/lib/libspreadsheet.so
	rm -f ${so}
	echo "INPUT(-lspreadsheet-${ver})" > ${so}
}
