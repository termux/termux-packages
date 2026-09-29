TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org/
TERMUX_PKG_DESCRIPTION="A library to communicate with services on iOS devices using native protocols"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_SRCURL=https://github.com/libimobiledevice/libimobiledevice/releases/download/${TERMUX_PKG_VERSION}/libimobiledevice-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=23cc0077e221c7d991bd0eb02150a0d49199bcca1ddf059edccee9ffd914939d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libimobiledevice-glue, libplist, libtatsu, libusbmuxd, openssl, usbmuxd"

termux_step_pre_configure() {
	autoreconf -fi
}
