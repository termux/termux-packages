# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 toolkit intrinsics library"
TERMUX_PKG_LICENSE="MIT, HPND"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXt-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=52820b3cdb827d08dc90bdfd1b0022a3ad8919b57a39808b12591973b331bf91
TERMUX_PKG_DEPENDS="libice, libsm, libx11"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_RAWCPP=/usr/bin/cpp
--enable-malloc0returnsnull
"

termux_step_pre_configure() {
	export CFLAGS_FOR_BUILD=" "
	export LDFLAGS_FOR_BUILD=" "
}
