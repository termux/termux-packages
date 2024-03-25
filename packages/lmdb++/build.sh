TERMUX_PKG_HOMEPAGE=https://github.com/hoytech/lmdbxx
TERMUX_PKG_DESCRIPTION="C++11 wrapper for the LMDB database library"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL="https://github.com/hoytech/lmdbxx/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5e12eb3aefe9050068af7df2c663edabc977ef34c9e7ba7b9d2c43e0ad47d8df
TERMUX_PKG_DEPENDS="liblmdb"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	make PREFIX="${TERMUX_PREFIX}" install
}
