TERMUX_PKG_HOMEPAGE=http://ipmitool.sourceforge.net
TERMUX_PKG_DESCRIPTION="Command-line interface to IPMI-enabled devices"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.8.18
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/ipmitool/ipmitool/$TERMUX_PKG_VERSION/ipmitool-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01
TERMUX_PKG_DEPENDS="ncurses, openssl, readline"

termux_step_pre_configure() {
	export LIBS="-llog"
}
