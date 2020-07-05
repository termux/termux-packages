# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.Org Autotools macros"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.19.2
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/util/util-macros-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d7e43376ad220411499a79735020f9d145fdc159284867e99467e0d771f3e712
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	mkdir -p ${TERMUX_PREFIX}/lib/pkgconfig
	mv ${TERMUX_PREFIX}/share/pkgconfig/xorg-macros.pc ${TERMUX_PREFIX}/lib/pkgconfig/
}
