TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 client-side library"
TERMUX_PKG_VERSION=1.6.6
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libX11-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=65fe181d40ec77f45417710c6a67431814ab252d21c2e85c75dd1ed568af414f
TERMUX_PKG_DEPENDS="libandroid-support, libxcb"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros, xtrans"
TERMUX_PKG_DEVPACKAGE_DEPENDS="xorgproto, xtrans"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-xthreads --enable-malloc0returnsnull"

termux_step_post_make_install() {
	ln -sfr "${TERMUX_PREFIX}/lib/libX11.so" "${TERMUX_PREFIX}/lib/libX11.so.6"
}
