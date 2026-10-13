TERMUX_PKG_HOMEPAGE=http://www.graphicsmagick.org/
TERMUX_PKG_DESCRIPTION="Collection of image processing tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.49"
# Bandwith limited on main ftp site, so it's asked to use sourceforge instead:
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/${TERMUX_PKG_VERSION}/GraphicsMagick-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7efa070dc31116b4315061b39f84bc7181e8b060bf61214ec9af851131af9c81
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, libbz2, libc++, libde265, libheif, libjasper, libjpeg-turbo, libjxl, liblzma, libpng, libtiff, libwebp, libxml2, littlecms, zlib, zstd"
TERMUX_PKG_BREAKS="graphicsmagick-dev"
TERMUX_PKG_REPLACES="graphicsmagick++, graphicsmagick-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_ftime=no
--with-fontpath=/system/fonts
--without-x
"

termux_step_pre_configure() {
	pushd "${TERMUX_PKG_SRCDIR}"
	# Otherwise shared libraries depend on libomp.so
	sed -i "s/-lomp/-l:libomp.a/g" configure.ac
	autoreconf -fi
	popd
	CFLAGS+=" -fPIC"
	CXXFLAGS+=" -fPIC"
}
