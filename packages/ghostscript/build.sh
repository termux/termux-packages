TERMUX_PKG_HOMEPAGE=https://www.ghostscript.com/
TERMUX_PKG_DESCRIPTION="Interpreter for the PostScript language and for PDF"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=10.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${TERMUX_PKG_VERSION//.}/ghostpdl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f30283f01a6966009a2e7b7553decdb5ec805501f3e24e5d86b0017fe16fbdba
TERMUX_PKG_DEPENDS="fontconfig, freetype, jbig2dec, libandroid-support, libc++, libiconv, libidn, libjpeg-turbo, libpng, libtiff, littlecms, openjpeg, zlib"
TERMUX_PKG_BUILD_DEPENDS="libexpat"
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
	rm -rdf $TERMUX_PKG_SRCDIR/{expat,freetype,jbig2dec,jpeg,lcms2mt,libpng,openjpeg,tiff,zlib}
}

termux_step_pre_configure() {
	# Use `make -j1` otherwise build may fail with error
	# about missing 'arch.h'.
	TERMUX_MAKE_PROCESSES=1
	CPPFLAGS+=" -I${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/include/c++/v1"

	# Workaround for build break caused by `sha2.h` from `libmd` package:
	if [ -e "$TERMUX_PREFIX/include/sha2.h" ]; then
		local inc="$TERMUX_PKG_BUILDDIR/_include"
		mkdir -p "${inc}"
		ln -sf "$TERMUX_PKG_SRCDIR/base/sha2.h" "${inc}/"
		CPPFLAGS="-I${inc} ${CPPFLAGS}"
	fi
}

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES \
		so all \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/bin/gs{c,}
}
