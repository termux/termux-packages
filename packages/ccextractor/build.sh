TERMUX_PKG_HOMEPAGE=https://ccextractor.org/
TERMUX_PKG_DESCRIPTION="A tool used to produce subtitles for TV recordings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.94
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/CCExtractor/ccextractor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9c7be386257c69b5d8cd9d7466dbf20e3a45cea950cc8ca7486a956c3be54a42
TERMUX_PKG_DEPENDS="freetype, gpac, libiconv, libmd, libpng, libprotobuf-c, utf8proc"
TERMUX_PKG_BUILD_DEPENDS="zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITHOUT_RUST=ON
"

termux_step_post_get_source() {
	rm -rf src/thirdparty
	touch src/lib_ccx/config.h
}

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/src"

	CPPFLAGS+=" -D__USE_GNU"
	CFLAGS+=" -fcommon"
	LDFLAGS+=" -liconv"
}
