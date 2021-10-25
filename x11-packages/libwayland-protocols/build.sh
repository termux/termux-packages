TERMUX_PKG_HOMEPAGE=https://wayland.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Wayland protocols library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://wayland.freedesktop.org/releases/wayland-protocols-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=df1319cf9705643aea9fd16f9056f4e5b2471bd10c0cc3713d4a4cdc23d6812f
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-documentation --with-host-scanner"

termux_step_post_make_install() {
	mv ${TERMUX_PREFIX}/share/pkgconfig/wayland-protocols.pc ${TERMUX_PREFIX}/lib/pkgconfig/
}
