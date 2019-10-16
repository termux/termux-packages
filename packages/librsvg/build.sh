TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=2.46.2
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/librsvg/${TERMUX_PKG_VERSION:0:4}/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=379ec0bbf9ce249c2bc03f4a124d8f532abe0916d908c5cf26821e5af1668197
TERMUX_PKG_DEPENDS="libcroco, pango, gdk-pixbuf, libcairo-gobject, zlib"
TERMUX_PKG_BREAKS="librsvg-dev"
TERMUX_PKG_REPLACES="librsvg-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-introspection --disable-pixbuf-loader"

termux_step_pre_configure() {
	termux_setup_rust

	LDFLAGS+=" -fuse-ld=lld"

	# See https://github.com/GNOME/librsvg/blob/master/COMPILING.md
	export RUST_TARGET=$CARGO_TARGET_NAME
}
