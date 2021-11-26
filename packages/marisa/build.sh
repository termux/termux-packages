TERMUX_PKG_HOMEPAGE=https://github.com/s-yata/marisa-trie
TERMUX_PKG_DESCRIPTION="Matching Algorithm with Recursively Implemented StorAge."
TERMUX_PKG_LICENSE="BSD 2-Clause, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.6
TERMUX_PKG_SRCURL=https://github.com/s-yata/marisa-trie/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1063a27c789e75afa2ee6f1716cc6a5486631dcfcb7f4d56d6485d2462e566de
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi
}
