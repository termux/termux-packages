TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org/
TERMUX_PKG_DESCRIPTION="A library to communicate with services on iOS devices using native protocols."
TERMUX_PKG_LICENSE="GPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_SRCURL=https://github.com/libimobiledevice/libimobiledevice/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=acbfb73eabee162e64c0d9de207d71c0a5f47c40cd5ad32a5097f734328ce10a
#TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	PKG_CONFIG_PATH=$TERMUX_PREFIX/lib/pkgconfig
        ./autogen.sh --prefix=$TERMUX_PREFIX \
		     --host=$TERMUX_HOST_PLATFORM
}
