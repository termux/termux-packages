TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org/
TERMUX_PKG_DESCRIPTION="A library to communicate with services on iOS devices using native protocols."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/libimobiledevice/libimobiledevice/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=acbfb73eabee162e64c0d9de207d71c0a5f47c40cd5ad32a5097f734328ce10a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="usbmuxd, libusbmuxd, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
        ./autogen.sh --prefix=$TERMUX_PREFIX \
		     --host=$TERMUX_HOST_PLATFORM
}
