TERMUX_PKG_HOMEPAGE=https://github.com/linuxhw/hw-probe
TERMUX_PKG_DESCRIPTION="Tool to probe for hardware and check its operability"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.6
TERMUX_PKG_SRCURL=https://github.com/linuxhw/hw-probe/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d8d31ed978095d0bd2ca7af51cfee8b97c97f7168ddb48a479a1632e1af84c7b
TERMUX_PKG_DEPENDS="curl, hwinfo, net-tools, perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	install -Dm700 hw-probe.pl "$TERMUX_PREFIX"/bin/hw-probe
}
