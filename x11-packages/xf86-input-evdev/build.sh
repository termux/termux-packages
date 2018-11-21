TERMUX_PKG_HOMEPAGE=http://x.org/
TERMUX_PKG_DESCRIPTION="Kernel evdev device driver"
TERMUX_PKG_VERSION=2.10.6
TERMUX_PKG_SRCURL=https://www.x.org/archive/individual/driver/xf86-input-evdev-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=8726073e81861bc7b2321e76272cbdbd33c7e1a121535a9827977265b9033ec0
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
#TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="xorg-server, libevdev, libmtdev"
termux_step_pre_configure() {
	autoreconf -if
	export LDFLAGS="$LDFLAGS -lXFree86"
}
