TERMUX_PKG_HOMEPAGE=http://enblend.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A tool for compositing images using a Burt&Adelson multiresolution spline"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=4.2.0_p20161007
TERMUX_PKG_VERSION=${_VERSION//_/}
TERMUX_PKG_SRCURL=https://dev.gentoo.org/~soap/distfiles/enblend-${_VERSION}.tar.xz
TERMUX_PKG_SHA256=4fe05af3d697bd6b2797facc8ba5aeabdc91e233156552301f1c7686232ff4c3
TERMUX_PKG_DEPENDS="gsl, libandroid-glob, libc++, libtiff, libvigra, littlecms"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, libjpeg-turbo, libpng, zlib"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" -landroid-glob"
}
