TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.52
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.7
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/librsvg/${_MAJOR_VERSION}/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=057c1eeeaf85c84e254bdb707459207f5840da5b4d52b4711c03140ed09e6887
TERMUX_PKG_DEPENDS="gdk-pixbuf, libcairo, pango, zlib"
TERMUX_PKG_BREAKS="librsvg-dev"
TERMUX_PKG_REPLACES="librsvg-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_GDK_PIXBUF_QUERYLOADERS=$TERMUX_PREFIX/bin/gdk-pixbuf-query-loaders
--disable-introspection
--disable-static
"

termux_step_pre_configure() {
	termux_setup_rust

	LDFLAGS+=" -fuse-ld=lld"

	# Work around https://gitlab.gnome.org/GNOME/librsvg/-/issues/820
	if [ "$TERMUX_ARCH" = "arm" ]; then
		LDFLAGS+=" -Wl,-z,muldefs"
	fi

	# See https://github.com/GNOME/librsvg/blob/master/COMPILING.md
	export RUST_TARGET=$CARGO_TARGET_NAME
}
