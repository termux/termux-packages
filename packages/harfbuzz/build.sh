TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/HarfBuzz/
TERMUX_PKG_DESCRIPTION="OpenType text shaping engine"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2620987115a4122b47321610dccbcc18f7f121115fd7b88dc8a695c8b66cb3c9
TERMUX_PKG_DEPENDS="freetype,glib,libbz2,libpng"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-icu=no"

termux_step_pre_configure () {
	# Needed to work with automake 1.15 since we patch Makefile.am
	cd $TERMUX_PKG_SRCDIR
	autoreconf
}
