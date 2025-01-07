TERMUX_PKG_HOMEPAGE=https://deadbeef.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A modular cross-platform audio player"
TERMUX_PKG_LICENSE="ZLIB, GPL-2.0, LGPL-2.1, BSD 3-Clause, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.6"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/deadbeef/deadbeef-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9d77b3d8afdeab5027d24bd18e9cfc04ce7d6ab3ddc043cc8e84c82b41b79c04
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, dbus, ffmpeg, gdk-pixbuf, glib, gtk3, harfbuzz, libblocksruntime, libc++, libcairo, libcurl, libdispatch, libflac, libiconv, libjansson, libmad, libogg, libsamplerate, libsndfile, libvorbis, libwavpack, libx11, libzip, mpg123, opusfile, pango, pulseaudio, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ax_cv_c_flags__msse2=no
--disable-ffap
--disable-gtk2
--disable-sid
"

termux_step_pre_configure() {
	declare -a _commits=(
	d4cca560
	)
	declare -a _checksums=(
	1a2a984af011fe393b6fc4c11a73e9035f23ab070bf6937b28948f130b6a73c8
	)
	for i in "${!_commits[@]}"; do
		PATCHFILE="${TERMUX_PKG_CACHEDIR}/deadbeef_patch_${_commits[i]}.patch"
		termux_download \
			"https://github.com/DeaDBeeF-Player/deadbeef/commit/${_commits[i]}.patch" \
			"$PATCHFILE" \
			"${_checksums[i]}"
		patch -p1 -i "$PATCHFILE"
	done

	autoreconf -fi

	CPPFLAGS+=" -Wno-implicit-function-declaration -D_FILE_OFFSET_BITS=64"
	LDFLAGS+=" -lm $($CC -print-libgcc-file-name)"

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
