TERMUX_PKG_HOMEPAGE=https://www.ghostscript.com/
TERMUX_PKG_DESCRIPTION="Interpreter for the PostScript language and for PDF"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.56.1
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${TERMUX_PKG_VERSION//.}/ghostpdl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6bf362286e359e31f934e5aad49db3d88a2382a3cac44b40572861ee5c536664
TERMUX_PKG_DEPENDS="fontconfig, libandroid-support, libiconv, libtiff, libjpeg-turbo, libpng, libexpat, freetype, libidn, littlecms, openjpeg, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_lcms2__cmsCreateMutex=yes
ac_cv_lib_pthread_pthread_create=yes
CCAUX=gcc
--build=$TERMUX_BUILD_TUPLE
--with-arch_h=$TERMUX_PKG_BUILDER_DIR/arch-${TERMUX_ARCH}.h
--disable-cups
--disable-compile-inits
--without-pcl
--without-x
--with-system-libtiff
"
TERMUX_PKG_MAKE_INSTALL_TARGET="install-so install"

termux_step_post_get_source() {
	rm -rdf $TERMUX_PKG_SRCDIR/{jpeg,libpng,expat,jasper,freetype,lcms2,tiff,openjpeg}
}

termux_step_pre_configure() {
	# Use `make -j1` otherwise build may fail with error
	# about missing 'arch.h'.
	TERMUX_MAKE_PROCESSES=1
	CPPFLAGS+=" -I${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/include/c++/v1"
}

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES \
		so all \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/bin/gs{c,}
}
