TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X transport library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=1.3.5
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/xtrans-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=adbd3b36932ce4c062cd10f57d78a156ba98d618bdb6f50664da327502bc8301
TERMUX_PKG_NO_DEVELSPLIT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	mkdir -p ${TERMUX_PREFIX}/lib/pkgconfig
	mv ${TERMUX_PREFIX}/share/pkgconfig/xtrans.pc ${TERMUX_PREFIX}/lib/pkgconfig
}
