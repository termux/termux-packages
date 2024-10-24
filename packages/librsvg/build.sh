TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.59.0"
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/librsvg/${TERMUX_PKG_VERSION%.*}/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=370d6ada5cf0de91ceb70d849ed069523ce5de2b33b4c7e86bc640673ad65483
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, gdk-pixbuf, glib, harfbuzz, libcairo, libpng, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="librsvg-dev"
TERMUX_PKG_REPLACES="librsvg-dev"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=disabled
-Dintrospection=enabled
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_meson
	termux_setup_rust
	termux_setup_cargo_c
	
	# termux_setup_rust unsets CFLAGS so we called termux_setup_meson before
	# we need to reset termux_setup_meson to avoid `line 70: CFLAGS: unbound variable` error
	termux_setup_meson() { :; }

	sed -i 's/@BUILD_TRIPLET@/'"$CARGO_TARGET_NAME"'/' "meson.build"

	LDFLAGS+=" -fuse-ld=lld"

	# Work around https://gitlab.gnome.org/GNOME/librsvg/-/issues/820
	if [ "$TERMUX_ARCH" = "arm" ]; then
		LDFLAGS+=" -Wl,-z,muldefs"
	fi

	# See https://github.com/GNOME/librsvg/blob/master/COMPILING.md
	export RUST_TARGET=$CARGO_TARGET_NAME
}

termux_step_post_massage() {
	find lib -name '*.la' -delete
}
