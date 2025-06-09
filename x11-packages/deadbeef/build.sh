TERMUX_PKG_HOMEPAGE=https://deadbeef.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A modular cross-platform audio player"
TERMUX_PKG_LICENSE="ZLIB, GPL-2.0, LGPL-2.1, BSD 3-Clause, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/deadbeef/travis/linux/${TERMUX_PKG_VERSION}/deadbeef-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=98d4247a76efb13bf65890aec9921f5c4733bfc1557906b8d6f209a66b28c363
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, dbus, ffmpeg, gdk-pixbuf, glib, gtk3, harfbuzz, libblocksruntime, libc++, libcairo, libcurl, libdispatch, libflac, libiconv, libjansson, libmad, libogg, libsamplerate, libsndfile, libvorbis, libwavpack, libx11, libzip, libmpg123, opusfile, pango, pulseaudio, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ax_cv_c_flags__msse2=no
--disable-ffap
--disable-gtk2
--disable-sid
"

termux_step_pre_configure() {
	autoreconf -fi

	CPPFLAGS+=" -Wno-implicit-function-declaration -D_FILE_OFFSET_BITS=64"

	# ERROR: ./lib/deadbeef/adplug.so contains undefined symbols: __extendsftf2
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -lm -L$_libgcc_path -l:$_libgcc_name"

	rm -rf intl
	mkdir -p intl
	cat > intl/Makefile.in <<-EOF
		all:
		install:
	EOF
}

termux_step_post_configure() {
	echo '!<arch>' >> intl/libintl.a
}

termux_step_post_make_install() {
	cd $TERMUX_PKG_SRCDIR
	local f
	for f in $(find plugins -name COPYING); do
		local d=$(dirname ${f})
		install -Dm600 -T $TERMUX_PKG_SRCDIR/${f} \
			$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING.${d//\//.}
	done
}
