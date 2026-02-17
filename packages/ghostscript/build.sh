TERMUX_PKG_HOMEPAGE=https://www.ghostscript.com/
TERMUX_PKG_DESCRIPTION="Interpreter for the PostScript language and for PDF"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.06.0"
TERMUX_PKG_SRCURL="https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${TERMUX_PKG_VERSION//.}/ghostpdl-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=80dd50abf5970f49140ca7c0c19475cc2707437f89e8a825e670ba101003f1d8
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="fontconfig, freetype, jbig2dec, leptonica, libandroid-support, libc++, libiconv, libidn, libjpeg-turbo, libpng, libtiff, littlecms, openjpeg, zlib"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, libexpat"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_lcms2__cmsCreateMutex=yes
ac_cv_lib_pthread_pthread_create=yes
CCAUX=gcc
--build=$TERMUX_BUILD_TUPLE
--disable-cups
--disable-compile-inits
--without-pcl
--without-x
--with-system-libtiff
"
TERMUX_PKG_MAKE_INSTALL_TARGET="install-so install"

termux_step_post_get_source() {
	rm -rdf "$TERMUX_PKG_SRCDIR"/{expat,freetype,jbig2dec,jpeg,lcms2mt,leptonica,libpng,openjpeg,tiff,zlib}
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_setup_proot
		local patch="$TERMUX_PKG_BUILDER_DIR/genarch-termux-proot-run.diff"
		echo "Applying $(basename "${patch}")"
		patch --silent -p1 < "${patch}"
	else
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
	make -j "$TERMUX_PKG_MAKE_PROCESSES" \
		so all \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_post_make_install() {
	mv "$TERMUX_PREFIX"/bin/gs{c,}
}
