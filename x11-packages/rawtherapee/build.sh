TERMUX_PKG_HOMEPAGE=https://www.rawtherapee.com/
TERMUX_PKG_DESCRIPTION="raw image converter and digital photo processor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="5.13"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Beep6581/RawTherapee/releases/download/${TERMUX_PKG_VERSION}/rawtherapee-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=23bdff4b1817e1274c11a94b11d21cac59e9c1b1d209795d3194710ee73e77bf
TERMUX_PKG_DEPENDS="exiv2, fftw, glib, gtk3, gtkmm3, lensfun, libcanberra, libexpat, libglibmm-2.4, libiptcdata, libjpeg-turbo, libpng, libraw, librsvg, libsigc++-2.0, libtiff, littlecms, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+"
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBINARY_PACKAGE_BUILD=ON
-DWITH_SYSTEM_LIBRAW=TRUE
"

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"
	CXXFLAGS+=" -DTERMUX_APP_PACKAGE_NAME=\\\"${TERMUX_APP__PACKAGE_NAME}\\\""
}
