# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 client-side library"
TERMUX_PKG_LICENSE="MIT, X11"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.4
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libX11-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c9a287a5aefa9804ce3cfafcf516fe96ed3f7e8e45c0e2ee59e84c86757df518
TERMUX_PKG_DEPENDS="libandroid-support, libxcb"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros, xtrans"
TERMUX_PKG_RECOMMENDS="xorg-xauth"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_RAWCPP=/usr/bin/cpp
--enable-malloc0returnsnull
"

termux_step_post_massage() {
	# Seems like some programs in the wild try to dlopen(3) `libX11.so.6`.
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libX11.so.6" ]; then
		ln -sf libX11.so libX11.so.6
	fi
}
