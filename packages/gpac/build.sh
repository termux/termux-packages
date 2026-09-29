TERMUX_PKG_HOMEPAGE=https://gpac.wp.imt.fr/
TERMUX_PKG_DESCRIPTION="An open-source multimedia framework focused on modularity and standards compliance"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.07.0"
TERMUX_PKG_SRCURL=https://github.com/gpac/gpac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=57822c1a74dcb83d76ff1f671e1b4fae2e7614e8194a5adb9f20661e0e9421dd
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
