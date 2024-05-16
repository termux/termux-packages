TERMUX_PKG_HOMEPAGE=https://github.com/ndevilla/iniparser
TERMUX_PKG_DESCRIPTION="Offers parsing of ini files from the C level"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.1"
TERMUX_PKG_SRCURL=https://github.com/ndevilla/iniparser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9120fd13260be1dbec74b8aaf47777c434976626f3b3288c0d17b70e21cce2d2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib libiniparser.so.1
	ln -sf libiniparser.so.1 $TERMUX_PREFIX/lib/libiniparser.so
	install -Dm600 -t $TERMUX_PREFIX/include/iniparser src/*.h
}
