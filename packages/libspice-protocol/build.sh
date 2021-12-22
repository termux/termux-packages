TERMUX_PKG_HOMEPAGE=https://www.spice-space.org/
TERMUX_PKG_DESCRIPTION="SPICE protocol headers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.14.3
TERMUX_PKG_SRCURL=https://www.spice-space.org/download/releases/spice-protocol-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f986e5bc2a1598532c4897f889afb0df9257ac21c160c083703ae7c8de99487a

termux_step_post_make_install() {
      mv "${TERMUX_PREFIX}"/share/pkgconfig/spice-protocol.pc \
      "${TERMUX_PREFIX}"/lib/pkgconfig
}
