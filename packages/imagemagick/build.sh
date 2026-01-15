TERMUX_PKG_HOMEPAGE=https://www.imagemagick.org/
TERMUX_PKG_DESCRIPTION="Suite to create, edit, compose, or convert images in a variety of formats"
TERMUX_PKG_LICENSE="ImageMagick"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.1.2.12"
TERMUX_PKG_REVISION=1
_VERSION="${TERMUX_PKG_VERSION%.*}-${TERMUX_PKG_VERSION##*.}"
TERMUX_PKG_SRCURL=https://imagemagick.org/archive/releases/ImageMagick-${_VERSION}.tar.xz
TERMUX_PKG_SHA256=e22c5dc6cd3f8e708a2809483fd10f8e37438ef7831ec8d3a07951ccd70eceba
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="djvulibre, fftw, fontconfig, freetype, gdk-pixbuf, ghostscript, glib, graphviz, harfbuzz, imath, jbig2dec, libandroid-support, libbz2, libc++, libcairo, libheif, libjpeg-turbo, libjxl, liblqr, libltdl, liblzma, libpng, libraqm, libraw, librsvg, libtiff, libwebp, libx11, libxext, libxml2, libzip, littlecms, openexr, openjpeg, pango, zlib"
TERMUX_PKG_BREAKS="imagemagick-dev, imagemagick-x"
TERMUX_PKG_REPLACES="imagemagick-dev, imagemagick-x"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-autotrace=no
--with-djvu=yes
--with-dmr=no
--with-dps=no
--with-fftw=yes
--with-flif=no
--with-fontconfig=yes
--with-fpx=no
--with-freetype=yes
--with-gslib=yes
--with-gvc=yes
--with-heic=yes
--with-jbig=yes
--with-jpeg=yes
--with-jxl=yes
--with-lcms=yes
--with-lqr=yes
--with-ltdl=yes
--with-lzma=yes
--with-magick-plus-plus=yes
--with-openexr=yes
--with-openjp2=yes
--with-pango=yes
--with-perl=no
--with-png=yes
--with-raqm=yes
--with-raw=yes
--with-rsvg=yes
--with-tiff=yes
--with-uhdr=no
--with-webp=yes
--with-wmf=no
--with-x=yes
--with-xml=yes
--with-zip=yes
--with-zlib=yes
--with-zstd=yes
--disable-openmp
ac_cv_func_ftime=no
"
# We do not currently have packages for:
# `autotrace` AutoTrace
# `dmr`       digital media repository
# `dps`       <<Obsolete>>
# `flif`      Free Lossless Image Format
# `fpx`       libfpx (Flashpix)
# `uhdr`      libultrahdr
# `wmf`       Windows Metafile Format

TERMUX_PKG_RM_AFTER_INSTALL="
share/ImageMagick-7/francais.xml
"

termux_step_pre_configure() {
	# ERROR: ./lib/libMagick++-7.Q16HDRI.so contains undefined symbols: __aeabi_idiv (arm)
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"

	# Value of PKG_CONFIG becomes hardcoded in bin/*-config
	export PKG_CONFIG=pkg-config
}
