TERMUX_PKG_HOMEPAGE=http://www.ghostscript.com/
TERMUX_PKG_DESCRIPTION="Interpreter for the PostScript language and for PDF"
TERMUX_PKG_VERSION=9.21
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${TERMUX_PKG_VERSION//.}/ghostpdl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=82abf56e96e27cf4d1b17c0671f9ab3c5222454131588a49d06c97a332988e8d
TERMUX_PKG_DEPENDS="libandroid-support, libtiff, libjpeg-turbo, libpng"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-libtiff \
--enable-little-endian \
--without-x \
--with-arch_h=$TERMUX_PKG_BUILDER_DIR/arch-arm.h \
CCAUX=gcc \
--build=$TERMUX_BUILD_TUPLE \
--without-pcl"

#building with PCL gives:
# /home/builder/.termux-build/ghostscript/src/pcl/pl/pl.mak:108: recipe for target 'obj/plver.h' failed
# make: *** [obj/plver.h] Segmentation fault (core dumped)
# make: *** Deleting file 'obj/plver.h'
#See also: https://bugs.ghostscript.com/show_bug.cgi?id=695979

termux_step_post_extract_package () {
        rm -rdf $TERMUX_PKG_SRCDIR/jpeg
	rm -rdf $TERMUX_PKG_SRCDIR/libpng
	
	if [ -f $PREFIX/include/libandroid-support/time.h ]; then
	    mv $PREFIX/include/libandroid-support/time.h $PREFIX/include/libandroid-support/time.h_
	fi
	# Patch needed to libandroid's time.h? ghostscript/src/base/stat_.h includes stat_.h which includes time.h which creates a loop.
	# See http://stackoverflow.com/questions/14947691/c-system-file-bits-stat-h-suddenly-breaks-with-error-field-st-atim-has-inc
}

termux_step_post_make_install () {
        if [ -f $PREFIX/include/libandroid-support/time.h_ ]; then
            mv $PREFIX/include/libandroid-support/time.h_ $PREFIX/include/libandroid-support/time.h
        fi
}
