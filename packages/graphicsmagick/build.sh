TERMUX_PKG_HOMEPAGE=http://www.graphicsmagick.org/
TERMUX_PKG_DESCRIPTION="Collection of image processing tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.45"
# Bandwith limited on main ftp site, so it's asked to use sourceforge instead:
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/${TERMUX_PKG_VERSION}/GraphicsMagick-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=dcea5167414f7c805557de2d7a47a9b3147bcbf617b91f5f0f4afe5e6543026b
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
}
