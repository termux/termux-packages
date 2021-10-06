TERMUX_PKG_HOMEPAGE=https://mupdf.com/
TERMUX_PKG_DESCRIPTION="Lightweight PDF and XPS viewer (library)"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.19.0
TERMUX_PKG_SRCURL=https://mupdf.com/downloads/archive/mupdf-${TERMUX_PKG_VERSION}-source.tar.xz
TERMUX_PKG_SHA256=38f39943e408d60a3e7d6c2fca0d705163540ca24d65682d4426dc6f1fee28c5
TERMUX_PKG_DEPENDS="freetype, gumbo-parser, harfbuzz, jbig2dec, libjpeg-turbo, openjpeg, zlib"
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX build=release libs shared=yes"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -rf thirdparty/{freeglut,freetype,harfbuzz,jbig2dec,libjpeg,openjpeg,zlib}
	export USE_SYSTEM_LIBS=yes
	LDFLAGS+=" -llog"
}
