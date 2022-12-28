# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 toolkit intrinsics library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXt-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=679cc08f1646dbd27f5e48ffe8dd49406102937109130caab02ca32c083a3d60
TERMUX_PKG_DEPENDS="libice, libsm, libx11"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"

termux_step_pre_configure() {
	export CFLAGS_FOR_BUILD=" "
	export LDFLAGS_FOR_BUILD=" "
}
