TERMUX_PKG_HOMEPAGE=https://libusb.info/hidapi
TERMUX_PKG_DESCRIPTION="Simple cross-platform library for communicating with HID devices"
TERMUX_PKG_LICENSE="GPL-3.0, BSD 3-Clause, custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, LICENSE-gpl3.txt, LICENSE-bsd.txt, LICENSE-orig.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.15.0
TERMUX_PKG_SRCURL="https://github.com/libusb/hidapi/archive/refs/tags/hidapi-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5d84dec684c27b97b921d2f3b73218cb773cf4ea915caee317ac8fc73cef8136
TERMUX_PKG_DEPENDS="libiconv, libusb"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"
