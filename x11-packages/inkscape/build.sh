TERMUX_PKG_HOMEPAGE=https://inkscape.org/
TERMUX_PKG_DESCRIPTION="Free and open source vector graphics editor"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://media.inkscape.org/dl/resources/file/inkscape-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c59a85453b699addebcd51c1dc07684dd96a10c8aec716b19551db50562e13f5
TERMUX_PKG_DEPENDS="boost, double-conversion, fontconfig, freetype, gdk-pixbuf, graphicsmagick, glib, gsl, gspell, gtk3, gtkmm3, gtksourceview4, harfbuzz, libatkmm-1.6, libc++, libcairo, libcairomm-1.0, libgc, libglibmm-2.4, libiconv, libjpeg-turbo, libpangomm-1.4, libpng, libsigc++-2.0, libsoup, libx11, libxml2, libxslt, littlecms, pango, poppler, potrace, readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_RECOMMENDS="inkscape-extensions, inkscape-tutorials"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_IMAGE_MAGICK=OFF
-DWITH_LIBCDR=OFF
-DWITH_LIBVISIO=OFF
-DWITH_LIBWPG=OFF
"

termux_step_pre_configure() {
	(	# Doing this in subshell to avoid messing with variables.
		# We should just download graphicsmagick and build it with -fPIC
		TERMUX_PKG_SRCDIR="$TERMUX_PKG_TMPDIR/graphicsmagick-src"
		TERMUX_PKG_BUILDDIR="$TERMUX_PKG_TMPDIR/graphicsmagick-build"
		TERMUX_PREFIX="$TERMUX_PKG_TMPDIR/graphicsmagick-prefix"
		mkdir -p "$TERMUX_PKG_SRCDIR" "$TERMUX_PKG_BUILDDIR" "$TERMUX_PREFIX"
		pwd
		. $TERMUX_SCRIPTDIR/packages/graphicsmagick/build.sh
		
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-shared --enable-static"
		
		cd "$TERMUX_PKG_SRCDIR"
		termux_step_get_source
		cd "$TERMUX_PKG_SRCDIR"
		termux_step_pre_configure
		CFLAGS+=" -fPIC"
		CXXFLAGS+=" -fPIC"
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_configure
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make_install
	)
	
	CPPFLAGS+=" -DCMS_NO_REGISTER_KEYWORD -I${TERMUX_PREFIX}/include/libxml2 -include libxml/xmlmemory.h"
	LDFLAGS="-L$TERMUX_PKG_TMPDIR/graphicsmagick-prefix/lib $LDFLAGS -fopenmp -static-openmp -Wl,-rpath=$TERMUX_PREFIX/lib/inkscape"
	export PKG_CONFIG_PATH="$TERMUX_PREFIX/lib/pkgconfig"
}

termux_step_install_license() {
	local license_file="$TERMUX_PREFIX/share/inkscape/doc/COPYING"
	if [ ! -e "$license_file" ]; then
		termux_error_exit "License file $license_file not found."
	fi
	local doc_dir="$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"
	mkdir -p "$doc_dir"
	ln -sf "$license_file" "$doc_dir"/
}
