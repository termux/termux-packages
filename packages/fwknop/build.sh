TERMUX_PKG_HOMEPAGE=http://www.cipherdyne.org/fwknop/
TERMUX_PKG_DESCRIPTION="FireWall KNock OPerator, Single Packet Authorization (SPA) client"
TERMUX_PKG_DEPENDS="gpgme, libpcap"
_TERMUX_PKG_MAJOR_VERSION=2.6.9
TERMUX_PKG_VERSION=${_TERMUX_PKG_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://cipherdyne.org/fwknop/download/fwknop-${_TERMUX_PKG_MAJOR_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-server"
#
# termux_step_pre_configure() {
# 	CFLAGS+=" -std=c99"
# }
