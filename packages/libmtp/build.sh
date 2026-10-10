TERMUX_PKG_HOMEPAGE=https://github.com/libmtp/libmtp
TERMUX_PKG_DESCRIPTION="A library for communicating with MTP devices"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@flipphoneguy"
TERMUX_PKG_VERSION=1.1.23
TERMUX_PKG_SRCURL=https://github.com/libmtp/libmtp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=93ba3f860805f793ffaec3886ed5a2c1ea0a2e0407974c1d1b732d4d38ce34bc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libusb, libiconv"
TERMUX_PKG_BUILD_DEPENDS="gettext"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-mtpz
--with-udev=/dev/null
"

termux_step_pre_configure() {
	ACLOCAL_FLAGS="-I ${TERMUX_PREFIX}/share/gettext/m4 -I m4"
	export ACLOCAL_FLAGS
	echo n | NOCONFIGURE=1 ./autogen.sh
}
