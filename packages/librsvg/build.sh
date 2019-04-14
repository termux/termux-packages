TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=2.45.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=600872dc608fe5e01bfd8d5b3046d01b53b99121bc5ab9663531b53630843700
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/librsvg/${TERMUX_PKG_VERSION:0:4}/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libcroco,pango,gdk-pixbuf,libcairo-gobject,zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-introspection --disable-pixbuf-loader"

termux_step_pre_configure() {
	termux_setup_rust

	# See https://github.com/GNOME/librsvg/blob/master/COMPILING.md
	export RUST_TARGET=$CARGO_TARGET_NAME
}
