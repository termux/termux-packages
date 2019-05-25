TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 toolkit intrinsics library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.1.5
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXt-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=46eeb6be780211fdd98c5109286618f6707712235fdd19df4ce1e6954f349f1a
TERMUX_PKG_DEPENDS="libice, libsm, libuuid, libx11, libxau, libxcb, libxdmcp"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"

termux_step_pre_configure() {
	export CFLAGS_FOR_BUILD=" "
	export LDFLAGS_FOR_BUILD=" "
}
