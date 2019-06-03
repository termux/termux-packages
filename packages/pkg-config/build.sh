TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/pkg-config/
TERMUX_PKG_DESCRIPTION="Helper tool used when compiling applications and libraries"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.29.2
TERMUX_PKG_SRCURL=https://pkgconfig.freedesktop.org/releases/pkg-config-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_RM_AFTER_INSTALL="bin/*-pkg-config"

termux_step_pre_configure() {
	rm -Rf $TERMUX_PREFIX/bin/*pkg-config
}
