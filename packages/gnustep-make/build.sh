TERMUX_PKG_HOMEPAGE=http://www.gnustep.org
TERMUX_PKG_DESCRIPTION="The GNUstep makefile package"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.9.1
TERMUX_PKG_SRCURL=https://github.com/gnustep/tools-make/archive/make-${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=78ef0f68402c379979a9a46499ac308fe5c1512aa198138c87649ee611aedf41
TERMUX_PKG_DEPENDS="libobjc2"

termux_step_pre_configure() {
	export OBJCXX="$CXX"
}
