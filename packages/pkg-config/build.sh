TERMUX_PKG_HOMEPAGE=http://www.freedesktop.org/wiki/Software/pkg-config/
TERMUX_PKG_DESCRIPTION="Helper tool used when compiling applications and libraries"
TERMUX_PKG_VERSION=0.29.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://pkgconfig.freedesktop.org/releases/pkg-config-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=beb43c9e064555469bd4390dcfd8030b1536e0aa103f08d7abf7ae8cac0cb001
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_RM_AFTER_INSTALL="bin/*-pkg-config"

termux_step_pre_configure () {
	rm -Rf $TERMUX_PREFIX/bin/*pkg-config
}
