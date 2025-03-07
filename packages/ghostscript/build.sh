TERMUX_PKG_HOMEPAGE=https://www.ghostscript.com/
TERMUX_PKG_DESCRIPTION="Interpreter for the PostScript language and for PDF"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.03.1"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${TERMUX_PKG_VERSION//.}/ghostpdl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ea9dd8768b64576bc4ee2d79611450c9e1edeb686f7824f3bf94b92457b882a
TERMUX_PKG_AUTO_UPDATE=false
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
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		export PKGCONFIG="$PKG_CONFIG"
		export LDFLAGS+=" -liconv"
	fi

	if [[ "${TERMUX_ARCH}" == "aarch64" ]]; then
		# https://github.com/llvm/llvm-project/issues/74361
		# NDK r27: clang++: error: unsupported option '-mfpu=' for target 'aarch64-linux-android24'
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-neon"
	fi
}

termux_step_make() {
	make -j $TERMUX_PKG_MAKE_PROCESSES \
		so all \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/bin/gs{c,}
}
