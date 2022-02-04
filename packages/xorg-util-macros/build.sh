# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.Org Autotools macros"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.19.3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/util/util-macros-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=0f812e6e9d2786ba8f54b960ee563c0663ddbe2434bf24ff193f5feab1f31971
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	mkdir -p ${TERMUX_PREFIX}/lib/pkgconfig
	mv ${TERMUX_PREFIX}/share/pkgconfig/xorg-macros.pc ${TERMUX_PREFIX}/lib/pkgconfig/
}
