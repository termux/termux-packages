TERMUX_PKG_HOMEPAGE=https://www.ghostscript.com/
TERMUX_PKG_DESCRIPTION="Interpreter for the PostScript language and for PDF"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_VERSION=9.52
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${TERMUX_PKG_VERSION//.}/ghostpdl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8f6e48325c106ae033bbae3e55e6c0b9ee5c6b57e54f7cd24fb80a716a93b06a
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, libtiff, libjpeg-turbo, libpng, libexpat, freetype, fontconfig, libidn, littlecms, openjpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_lcms2__cmsCreateMutex=yes
CCAUX=gcc
--build=$TERMUX_BUILD_TUPLE
--with-arch_h=$TERMUX_PKG_BUILDER_DIR/arch-${TERMUX_ARCH}.h
--without-pcl
--without-x
--with-system-libtiff
"

termux_step_post_extract_package() {
	rm -rdf $TERMUX_PKG_SRCDIR/{jpeg,libpng,expat,jasper,freetype,lcms2,tiff,openjpeg}
}

termux_step_pre_configure() {
	# Use `make -j1` otherwise build may fail with error
	# about missing 'arch.h'.
	TERMUX_MAKE_PROCESSES=1
}
