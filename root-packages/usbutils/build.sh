TERMUX_PKG_HOMEPAGE=http://www.linux-usb.org/
TERMUX_PKG_DESCRIPTION="Collection of USB tools to query connected USB devices"
TERMUX_PKG_LICENSE="CC0-1.0, GPL-2.0-only, GPL-2.0-or-later, GPL-3.0-only, LGPL-2.1-or-later, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSES/CC0-1.0.txt
LICENSES/GPL-2.0-only.txt
LICENSES/GPL-2.0-or-later.txt
LICENSES/GPL-3.0-only.txt
LICENSES/LGPL-2.1-or-later.txt
LICENSES/MIT.txt
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="020"
TERMUX_PKG_SRCURL="https://www.kernel.org/pub/linux/utils/usb/usbutils/usbutils-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=20287d68fcd9ebb50a05ba0645a4af7583bd8dfc7307215ba121e4bc6d057aa1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="hwdata, libiconv, libusb"

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}

termux_step_post_make_install() {
	install -vDm 755 "$TERMUX_PKG_BUILDDIR/usbreset" -t "$TERMUX_PREFIX/bin"
}
