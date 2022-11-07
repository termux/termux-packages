TERMUX_PKG_HOMEPAGE=https://mupdf.com/
TERMUX_PKG_DESCRIPTION="Lightweight PDF and XPS viewer (library)"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.20.3
TERMUX_PKG_SRCURL=https://mupdf.com/downloads/archive/mupdf-${TERMUX_PKG_VERSION}-source.tar.lz
TERMUX_PKG_SHA256=6f73f63ef8aa81991dfd023d4426a548827d1d74e0bfcf2a013acad63b651868
TERMUX_PKG_DEPENDS="freetype, gumbo-parser, harfbuzz, jbig2dec, libc++, libjpeg-turbo, openjpeg, tesseract, zlib"
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX build=release libs shared=yes tesseract=yes"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = "i686" ]; then
		TERMUX_PKG_EXTRA_MAKE_ARGS="${TERMUX_PKG_EXTRA_MAKE_ARGS/tesseract=yes/}"
	fi
	rm -rf thirdparty/{freeglut,freetype,harfbuzz,jbig2dec,leptonica,libjpeg,openjpeg,tesseract,zlib}
	export USE_SYSTEM_LIBS=yes
	LDFLAGS+=" -llog"
}

termux_step_post_make_install() {
	TERMUX_PKG_EXTRA_MAKE_ARGS="${TERMUX_PKG_EXTRA_MAKE_ARGS/shared=yes/}"
	termux_step_make
	install -Dm600 -t $TERMUX_PREFIX/lib build/release*/libmupdf{-third,}.a
}
