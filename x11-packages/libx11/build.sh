TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 client-side library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.6.7
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libX11-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=910e9e30efba4ad3672ca277741c2728aebffa7bc526f04dcfa74df2e52a1348
TERMUX_PKG_DEPENDS="libandroid-support, libxcb, x11-repo (>= 1.3)"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros, xtrans"
TERMUX_PKG_DEVPACKAGE_DEPENDS="xorgproto, xtrans"
TERMUX_PKG_RECOMMENDS="xorg-xauth"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-xthreads --enable-malloc0returnsnull"

termux_step_post_make_install() {
	ln -sfr "${TERMUX_PREFIX}/lib/libX11.so" "${TERMUX_PREFIX}/lib/libX11.so.6"
}
