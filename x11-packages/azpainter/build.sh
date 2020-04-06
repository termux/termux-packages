TERMUX_PKG_HOMEPAGE=https://github.com/Symbian9/azpainter
TERMUX_PKG_DESCRIPTION="Full color painting software for Unix-like systems for illustration drawing (unofficial)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
_COMMIT=4bf18c83bb3edc5c0a2c557095ddee61b0b66a7a
TERMUX_PKG_VERSION=1:2.1.5
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/Symbian9/azpainter/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=84c150611407cdbdb757f0e872bb3da76892fd3c1ea45931385d3c1f9619e405
TERMUX_PKG_DEPENDS="fontconfig, hicolor-icon-theme, libandroid-shmem, libjpeg-turbo, libxfixes, libxi"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-freetype-dir=$TERMUX_PREFIX/include/freetype2
LIBS=-landroid-shmem
"
