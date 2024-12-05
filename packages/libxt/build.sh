# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 toolkit intrinsics library"
TERMUX_PKG_LICENSE="MIT, HPND"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.1"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXt-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e0a774b33324f4d4c05b199ea45050f87206586d81655f8bef4dba434d931288
TERMUX_PKG_AUTO_UPDATE=true
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
