TERMUX_PKG_HOMEPAGE=http://www.ghostscript.com/
TERMUX_PKG_DESCRIPTION="Interpreter for the PostScript language and for PDF"
TERMUX_PKG_VERSION=9.21
TERMUX_PKG_SRCURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${TERMUX_PKG_VERSION//.}/ghostpdl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=82abf56e96e27cf4d1b17c0671f9ab3c5222454131588a49d06c97a332988e8d
TERMUX_PKG_DEPENDS="libandroid-support, libtiff, libjpeg-turbo, libpng, libexpat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-libtiff \
--enable-little-endian \
--without-x \
--with-arch_h=$TERMUX_PKG_BUILDER_DIR/arch-${TERMUX_ARCH}.h \
CCAUX=gcc \
--build=$TERMUX_BUILD_TUPLE \
--without-pcl"

termux_step_post_extract_package () {
        rm -rdf $TERMUX_PKG_SRCDIR/{jpeg,libpng,expat,jasper,freetype,lcms,tiff}
}
