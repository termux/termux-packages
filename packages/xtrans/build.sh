# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X transport library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/xtrans-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=377c4491593c417946efcd2c7600d1e62639f7a8bbca391887e2c4679807d773
TERMUX_PKG_NO_DEVELSPLIT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	mkdir -p ${TERMUX_PREFIX}/lib/pkgconfig
	mv ${TERMUX_PREFIX}/share/pkgconfig/xtrans.pc ${TERMUX_PREFIX}/lib/pkgconfig
}
