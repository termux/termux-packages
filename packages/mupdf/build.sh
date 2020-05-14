TERMUX_PKG_HOMEPAGE=https://mupdf.com/
TERMUX_PKG_DESCRIPTION="Lightweight PDF and XPS viewer (library)"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_VERSION=1.17.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mupdf.com/downloads/archive/mupdf-${TERMUX_PKG_VERSION}-source.tar.xz
TERMUX_PKG_SHA256=c935fb2593d9a28d9b56b59dad6e3b0716a6790f8a257a68fa7dcb4430bc6086
TERMUX_PKG_DEPENDS="freetype, harfbuzz, jbig2dec, libjpeg-turbo, openjpeg, zlib"
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX build=release libs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_DEVELSPLIT=true
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true

termux_step_pre_configure() {
	rm -rf thirdparty/{freeglut,freetype,harfbuzz,jbig2dec,libjpeg,openjpeg,zlib}
	export USE_SYSTEM_LIBS=yes
	LDFLAGS+=" -llog"
}
