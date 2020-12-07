# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 toolkit intrinsics library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_REVISION=15
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXt-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b31df531dabed9f4611fc8980bc51d7782967e2aff44c4105251a1acb5a77831
TERMUX_PKG_DEPENDS="libice, libsm, libuuid, libx11, libxau, libxcb, libxdmcp"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"

termux_step_pre_configure() {
	export CFLAGS_FOR_BUILD=" "
	export LDFLAGS_FOR_BUILD=" "
}
