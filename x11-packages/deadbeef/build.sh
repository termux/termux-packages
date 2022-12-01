TERMUX_PKG_HOMEPAGE=https://deadbeef.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A modular cross-platform audio player"
TERMUX_PKG_LICENSE="ZLIB, GPL-2.0, LGPL-2.1, BSD 3-Clause, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/deadbeef/deadbeef-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c2c3a78c9e85b06a30b45b0432a830253bff71b458927dcb23ac90681e863e2f
TERMUX_PKG_DEPENDS="atk, dbus, ffmpeg, gdk-pixbuf, glib, gtk3, harfbuzz, libblocksruntime, libc++, libcairo, libcurl, libdispatch, libflac, libiconv, libjansson, libmad, libogg, libsamplerate, libsndfile, libvorbis, libwavpack, libx11, libzip, mpg123, opusfile, pango, pulseaudio, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ax_cv_c_flags__msse2=no
--disable-ffap
--disable-gme
--disable-gtk2
--disable-sid
"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" -lm $($CC -print-libgcc-file-name)"

	rm -rf intl
	mkdir -p intl
	cat > intl/Makefile.in <<-EOF
		all:
		install:
	EOF

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
}

termux_step_post_configure() {
	echo '!<arch>' >> intl/libintl.a
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi

	cd $TERMUX_PKG_SRCDIR
	local f
	for f in $(find plugins -name COPYING); do
		local d=$(dirname ${f})
		install -Dm600 -T $TERMUX_PKG_SRCDIR/${f} \
			$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING.${d//\//.}
	done
}
