TERMUX_PKG_HOMEPAGE=http://landley.net/toybox/
TERMUX_PKG_DESCRIPTION="Common Linux command line utilities"
TERMUX_PKG_VERSION=0.7.3
TERMUX_PKG_SRCURL=http://landley.net/toybox/downloads/toybox-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e6469b508224e0d2e4564dda05c4bb47aef5c28bf29d6c983bcdc6e3a0cd29d6
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	make defconfig
}
