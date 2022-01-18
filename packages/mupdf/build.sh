TERMUX_PKG_HOMEPAGE=https://mupdf.com/
TERMUX_PKG_DESCRIPTION="Lightweight PDF and XPS viewer (library)"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.18.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://mupdf.com/downloads/archive/mupdf-${TERMUX_PKG_VERSION}-source.tar.xz
TERMUX_PKG_SHA256=592d4f6c0fba41bb954eb1a41616661b62b134d5b383e33bd45a081af5d4a59a
TERMUX_PKG_DEPENDS="freetype, gumbo-parser, harfbuzz, jbig2dec, libjpeg-turbo, openjpeg, zlib"
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX build=release libs shared=yes"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -rf thirdparty/{freeglut,freetype,harfbuzz,jbig2dec,libjpeg,openjpeg,zlib}
	export USE_SYSTEM_LIBS=yes
	LDFLAGS+=" -llog"
}

termux_step_post_make_install() {
	TERMUX_PKG_EXTRA_MAKE_ARGS="${TERMUX_PKG_EXTRA_MAKE_ARGS/shared=yes/}"
	termux_step_make
	install -Dm600 -t $TERMUX_PREFIX/lib build/release/libmupdf{-third,}.a
}
