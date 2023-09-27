TERMUX_PKG_HOMEPAGE=https://github.com/linuxhw/hw-probe
TERMUX_PKG_DESCRIPTION="Tool to probe for hardware and check its operability"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.5
TERMUX_PKG_SRCURL=https://github.com/linuxhw/hw-probe/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=42030ba2fb3f6fb0772ab34744fbb91a89b1b6a9b0ed99e861fa05ff86968fb1
TERMUX_PKG_DEPENDS="curl, hwinfo, net-tools, perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	install -Dm700 hw-probe.pl "$TERMUX_PREFIX"/bin/hw-probe
}
