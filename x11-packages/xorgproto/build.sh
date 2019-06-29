TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.Org X11 Protocol headers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2019.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/proto/xorgproto-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a6daaa7a6cbc8e374032d83ff7f47d41be98f1e0f4475d66a4da3aa766a0d49b
TERMUX_PKG_DEPENDS="xorg-util-macros"
TERMUX_PKG_CONFLICTS="x11-proto"
TERMUX_PKG_REPLACES="x11-proto"
TERMUX_PKG_NO_DEVELSPLIT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dlegacy=true"

TERMUX_PKG_RM_AFTER_INSTALL="
include/X11/extensions/apple*
include/X11/extensions/windows*
lib/pkgconfig/applewmproto.pc
lib/pkgconfig/windowswmproto.pc
"

termux_step_pre_configure() {
	# Use meson instead of autotools.
	rm -f "$TERMUX_PKG_SRCDIR"/configure
}
