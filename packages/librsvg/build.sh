TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=2.45.6
TERMUX_PKG_SHA256=0e6e26cb5c79cfa73c0ddab06808ace4d10c4a626b81c31a75ead37c6cb4df41
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/librsvg/${TERMUX_PKG_VERSION:0:4}/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libcroco,pango,gdk-pixbuf,libcairo-gobject,zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-introspection --disable-pixbuf-loader"

termux_step_pre_configure() {
	termux_setup_rust

	# See https://github.com/GNOME/librsvg/blob/master/COMPILING.md
	export RUST_TARGET=$CARGO_TARGET_NAME
}
