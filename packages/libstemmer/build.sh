TERMUX_PKG_HOMEPAGE=https://snowballstem.org/
TERMUX_PKG_DESCRIPTION="Snowball compiler and stemming algorithms"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=https://github.com/snowballstem/snowball/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=425cdb5fba13a01db59a1713780f0662e984204f402d3dae1525bda9e6d30f1a
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local patch_url="https://github.com/gentoo/gentoo/raw/705bd7479a5a30cb75fc5bb29155f02c2d6b1ad6/dev-libs/snowball-stemmer/files/snowball-stemmer-2.2.0-shared-library.patch"
	local patch_filename="$(basename $patch_url)"
	termux_download \
		"$patch_url" \
		$TERMUX_PKG_CACHEDIR/"$patch_filename" \
		7695286b9fd0ad7c4db01fb4def3dc047bdfa20d3fcc1902959d8c4e6848e703
	cat $TERMUX_PKG_CACHEDIR/"$patch_filename" | patch --silent -p1
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin stemwords
	install -Dm600 -t $TERMUX_PREFIX/include include/libstemmer.h
	install -Dm600 -t $TERMUX_PREFIX/lib libstemmer.a

	local f
	for f in libstemmer.so*; do
		if test -L "${f}"; then
			ln -sf "$(readlink "${f}")" $TERMUX_PREFIX/lib/"${f}"
		else
			install -Dm600 -t $TERMUX_PREFIX/lib "${f}"
		fi
	done
}
