TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org
TERMUX_PKG_DESCRIPTION="A small portable C library to handle Apple Property List files in binary or XML format."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=https://github.com/libimobiledevice/libplist/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7e654bdd5d8b96f03240227ed09057377f06ebad08e1c37d0cfa2abe6ba0cee2
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
        PKG_CONFIG_PATH=$TERMUX_PREFIX/lib/pkgconfig
        ./autogen.sh --prefix=$TERMUX_PREFIX \
		     --without-cython \
                     --host=$TERMUX_HOST_PLATFORM
}

