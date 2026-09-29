TERMUX_PKG_HOMEPAGE=https://fontforge.org/
TERMUX_PKG_DESCRIPTION="A free (libre) font editor"
TERMUX_PKG_LICENSE="GPL-3.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING.gplv3, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20251009"
TERMUX_PKG_SRCURL="https://github.com/fontforge/fontforge/releases/download/${TERMUX_PKG_VERSION}/fontforge-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=69046500185a5581b58139dfad30c0b3d8128f00ebbfddc31f2fcf877e329e52
TERMUX_PKG_DEPENDS="freetype, giflib, glib, gtk3, gtkmm3, libc++, libcairo, libiconv, libjpeg-turbo, libpng, libtiff, libxml2, pango, readline, woff2, zlib"
TERMUX_PKG_CONFLICTS="fontforge"
TERMUX_PKG_REPLACES="fontforge"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_PYTHON_SCRIPTING=OFF
-DENABLE_PYTHON_EXTENSION=OFF
-DENABLE_LIBSPIRO=OFF
-DENABLE_DOCS=OFF
-DMathLib_IS_BUILT_IN=ON
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
