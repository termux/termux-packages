TERMUX_PKG_HOMEPAGE=https://github.com/Martchus/tagparser
TERMUX_PKG_DESCRIPTION="C++ library for reading and writing MP4 (iTunes), ID3, Vorbis, Opus, FLAC and Matroska tags"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=11.5.0
TERMUX_PKG_SRCURL=https://github.com/Martchus/tagparser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=361401093cd8855ba11403f10658e843417d00894c1af82b720cd106b9d814d2
TERMUX_PKG_DEPENDS="libc++, libc++utilities, zlib"
TERMUX_PKG_BUILD_DEPENDS="iso-codes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DLANGUAGE_FILE_ISO_639_2=$TERMUX_PREFIX/share/iso-codes/json/iso_639-2.json
"

termux_step_pre_configure() {
	CXXFLAGS+=" -std=c++17"
}
