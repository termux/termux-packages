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
TERMUX_PKG_VERSION="019"
TERMUX_PKG_SRCURL="https://www.kernel.org/pub/linux/utils/usb/usbutils/usbutils-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=659f40c440e31ba865c52c818a33d3ba6a97349e3353f8b1985179cb2aa71ec5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="hwdata, libiconv, libusb"

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}

termux_step_post_make_install() {
	install -vDm 755 "$TERMUX_PKG_BUILDDIR/usbreset" -t "$TERMUX_PREFIX/bin"
}
