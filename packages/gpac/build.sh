TERMUX_PKG_HOMEPAGE=https://gpac.wp.imt.fr/
TERMUX_PKG_DESCRIPTION="An open-source multimedia framework focused on modularity and standards compliance"
# License: LGPL-2.1-or-later
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/gpac/gpac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c20c204b57da76e4726109993c1abcdb3231a9b2ee2c8e21126d000cda7fc00d
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

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
}
