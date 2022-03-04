TERMUX_PKG_HOMEPAGE=https://github.com/ndevilla/iniparser
TERMUX_PKG_DESCRIPTION="Offers parsing of ini files from the C level"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1
TERMUX_PKG_SRCURL=https://github.com/ndevilla/iniparser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=960daa800dd31d70ba1bacf3ea2d22e8ddfc2906534bf328319495966443f3ae
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib libiniparser.so.1
	ln -sf libiniparser.so.1 $TERMUX_PREFIX/lib/libiniparser.so
	install -Dm600 -t $TERMUX_PREFIX/include/iniparser src/*.h
}
