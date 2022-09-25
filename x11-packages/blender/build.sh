TERMUX_PKG_HOMEPAGE=https://www.blender.org
TERMUX_PKG_DESCRIPTION="A fully integrated 3D graphics creation suite"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.1
TERMUX_PKG_SRCURL=https://github.com/blender/blender/archive/refs/tags/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=4e5dd8657733a4673b828c07e32bf05c78b05b7cd1c76e91d32ef6d5bba88558

# FIXME : Following packages are to be added:
#
# opencollada, openshadinglanguage, openimagedenoise, 
# OSL, USD 

TERMUX_PKG_DEPENDS="libpng, libtiff, python, python-numpy, openexr, desktop-file-utils, potrace, shared-mime-info, hicolor-icon-theme, glew, openjpeg, freetype, ffmpeg, fftw, alembic, libsndfile, ptex, sdl2, libspnav, openal-soft, libspnav, opencolorio, libblosc, sse2neon, embree, brotli"

TERMUX_PKG_PYTHON_COMMON_DEPS="requests, zstandard"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPYTHON_LIBRARY=$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION
-DPYTHON_INCLUDE_DIR=$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION
-DPYTHON_VERSION=3.11
-DPYTHON_SITE_PACKAGES=$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/site-packages
-DPYTHON_EXECUTABLE=$TERMUX_PREFIX/bin/python$TERMUX_PYTHON_VERSION
-DWITH_CYCLES_NATIVE_ONLY=ON
-DWITH_CYCLES_EMBREE=OFF
"
# Embree 3 is used in blender but I am using 4
#-DEMBREE_INCLUDE_DIR=$TERMUX_PREFIX/include/embree4
#-DMEBREE_LIBRARIES=$TERMUX_PREFIX/lib/

termux_step_pre_configure(){
    sed -i '45 a\#define FT_CONFIG_OPTION_USE_BROTLI' $TERMUX_PREFIX/include/freetype2/freetype/config/ftconfig.h
}
