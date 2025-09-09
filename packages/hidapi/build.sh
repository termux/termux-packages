TERMUX_PKG_HOMEPAGE=https://libusb.info/hidapi
TERMUX_PKG_DESCRIPTION="Simple cross-platform library for communicating with HID devices"
TERMUX_PKG_LICENSE="GPL-3.0, BSD 3-Clause, custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, LICENSE-gpl3.txt, LICENSE-bsd.txt, LICENSE-orig.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.14.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/libusb/hidapi/archive/refs/tags/hidapi-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a5714234abe6e1f53647dd8cba7d69f65f71c558b7896ed218864ffcf405bcbd
TERMUX_PKG_DEPENDS="libiconv, libusb, libprotobuf-c, termux-api"

termux_step_pre_configure() {
	export CFLAGS+=" -DDEBUG_PRINTF=1"
}
