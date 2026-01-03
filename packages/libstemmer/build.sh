TERMUX_PKG_HOMEPAGE=https://snowballstem.org/
TERMUX_PKG_DESCRIPTION="Snowball compiler and stemming algorithms"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.1"
TERMUX_PKG_SRCURL="https://github.com/snowballstem/snowball/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=80ac10ce40dc4fcfbfed8d085c457b5613da0e86a73611a3d5527d044a142d60
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_IN_SRC=true

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
