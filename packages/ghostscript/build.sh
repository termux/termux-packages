TERMUX_PKG_HOMEPAGE=https://www.ghostscript.com/
TERMUX_PKG_DESCRIPTION="Interpreter for the PostScript language and for PDF"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.54.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${TERMUX_PKG_VERSION//.}/ghostpdl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=63e54cddcdf48ea296b6315353f86b8a622d4e46959b10d536297e006b85687b
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, libtiff, libjpeg-turbo, libpng, libexpat, freetype, libidn, littlecms, openjpeg, zstd"
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

termux_step_post_get_source() {
	rm -rdf $TERMUX_PKG_SRCDIR/{jpeg,libpng,expat,jasper,freetype,lcms2,tiff,openjpeg}
}

termux_step_pre_configure() {
	# Use `make -j1` otherwise build may fail with error
	# about missing 'arch.h'.
	TERMUX_MAKE_PROCESSES=1
	CPPFLAGS+=" -I${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/include/c++/v1"
}
