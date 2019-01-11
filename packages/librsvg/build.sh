TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_VERSION=2.45.2
TERMUX_PKG_SHA256=c0a7bc5fc3944a172f95fc3c2be024f7d00fc7eca7e8724f19b7545f77503e34
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/librsvg/${TERMUX_PKG_VERSION:0:4}/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libcroco,pango,gdk-pixbuf,libcairo-gobject"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-introspection --disable-pixbuf-loader"

termux_step_pre_configure() {
	termux_setup_rust

	# See https://github.com/GNOME/librsvg/blob/master/COMPILING.md
	export RUST_TARGET=$CARGO_TARGET_NAME
}
