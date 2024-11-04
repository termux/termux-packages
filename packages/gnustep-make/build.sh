TERMUX_PKG_HOMEPAGE=http://www.gnustep.org
TERMUX_PKG_DESCRIPTION="The GNUstep makefile package"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/gnustep/tools-make/archive/make-${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=b3fdee058879675f6979c553fb6172b160ca79ffd0f170f51379326b7922941a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='(?<=make-)\d+\_\d+\_\d+'
TERMUX_PKG_DEPENDS="libobjc2"

termux_step_pre_configure() {
	export OBJCXX="$CXX"
}
