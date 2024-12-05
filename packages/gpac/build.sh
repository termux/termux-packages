TERMUX_PKG_HOMEPAGE=https://gpac.wp.imt.fr/
TERMUX_PKG_DESCRIPTION="An open-source multimedia framework focused on modularity and standards compliance"
# License: LGPL-2.1-or-later
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.0"
TERMUX_PKG_SRCURL=https://github.com/gpac/gpac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=99c8c994d5364b963d18eff24af2576b38d38b3460df27d451248982ea16157a
TERMUX_PKG_DEPENDS="ffmpeg, freetype, liba52, libjpeg-turbo, liblzma, libmad, libnghttp2, libogg, libpng, libtheora, libvorbis, openjpeg, openssl, pulseaudio, xvidcore, zlib"
TERMUX_PKG_EXTRA_MAKE_ARGS="STRIP=:"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-x11"

termux_step_pre_configure() {
	CFLAGS+=" -fPIC"
	for f in $CFLAGS $CPPFLAGS; do
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --extra-cflags=$f"
	done
	for f in $LDFLAGS; do
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --extra-ldflags=$f"
	done
}
