TERMUX_PKG_HOMEPAGE=https://github.com/linuxhw/hw-probe
TERMUX_PKG_DESCRIPTION="Tool to probe for hardware and check its operability"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/linuxhw/hw-probe/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8bb7d6ff272c1412e26fcfd86e9df5c3e34e1584552404b930c281b8498b25ea
TERMUX_PKG_DEPENDS="curl, hwinfo, net-tools, perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	install -Dm700 hw-probe.pl "$TERMUX_PREFIX"/bin/hw-probe
}
