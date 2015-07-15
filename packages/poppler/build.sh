TERMUX_PKG_HOMEPAGE=http://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_VERSION=0.34.0
TERMUX_PKG_SRCURL=http://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
# libcairo and littlecms is used by pdftocairo:
TERMUX_PKG_DEPENDS="fontconfig, libcairo, libpng, libjpeg-turbo, libtiff, littlecms, libgnustl, openjpeg"

# $NDK/docs/STANDALONE-TOOLCHAIN.html: "If you use the GNU libstdc++, you will need to explicitly link with libsupc++ if you use these features"
export LDFLAGS="$LDFLAGS -lgnustl_shared" # -lsupc++"
