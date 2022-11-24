TERMUX_PKG_HOMEPAGE="http://libnova.sourceforge.net"
TERMUX_PKG_DESCRIPTION="A general purpose, double precision, Celestial Mechanics, Astrometry and Astrodynamics library"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.16
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/libn/libnova/libnova_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=5dea5b29cba777ab8de4fd30cdfdbc1728fe1b3c573902270c1106bad55439a2
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi
}
