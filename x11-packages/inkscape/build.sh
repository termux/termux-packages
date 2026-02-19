TERMUX_PKG_HOMEPAGE=https://inkscape.org/
TERMUX_PKG_DESCRIPTION="Free and open source vector graphics editor"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-2.0-or-later, GPL-3.0, GPL-3.0-or-later, LGPL-2.1, LGPL-2.1-or-later, LGPL-3.0, LGPL-3.0-or-later, Mozilla-1.1, OFL-1.1"
TERMUX_PKG_LICENSE_FILE="
LICENSES/GPL-2.0.txt,
LICENSES/GPL-2.0-or-later.txt,
LICENSES/GPL-3.0.txt,
LICENSES/GPL-3.0-or-later.txt,
LICENSES/LGPL-2.1.txt,
LICENSES/LGPL-2.1-or-later.txt,
LICENSES/LGPL-3.0.txt,
LICENSES/LGPL-3.0-or-later.txt,
LICENSES/MPL-1.1.txt,
LICENSES/OFL-1.1.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.3"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://media.inkscape.org/dl/resources/file/inkscape-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=e83a2c3db570b6c5a1ff0fccfe7098837b3f6bd74b133567937c8a91710ed1d1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, double-conversion, fontconfig, freetype, gdk-pixbuf, glib, gsl, gspell, gtk3, gtkmm3, gtksourceview4, harfbuzz, libatkmm-1.6, libc++, libcairo, libcairomm-1.0, libgc, libglibmm-2.4, libiconv, libjasper, libjpeg-turbo, libpangomm-1.4, libpng, libsigc++-2.0, libsoup, libx11, libxml2, libxslt, littlecms, pango, poppler, potrace, readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, graphicsmagick-static"
TERMUX_PKG_RECOMMENDS="inkscape-extensions, inkscape-tutorials"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_IMAGE_MAGICK=OFF
-DWITH_LIBCDR=OFF
-DWITH_LIBVISIO=OFF
-DWITH_LIBWPG=OFF
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DCMS_NO_REGISTER_KEYWORD -I${TERMUX_PREFIX}/include/libxml2 -include libxml/xmlmemory.h"
	LDFLAGS+=" -fopenmp -static-openmp -Wl,-rpath=$TERMUX_PREFIX/lib/inkscape"
}
