TERMUX_PKG_HOMEPAGE=http://www.gnustep.org
TERMUX_PKG_DESCRIPTION="The GNUstep makefile package"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.9.0
TERMUX_PKG_SRCURL=http://ftp.gnustep.org/pub/gnustep/core/gnustep-make-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a0b066c11257879c7c85311dea69c67f6dc741ef339db6514f85b64992c40d2a
TERMUX_PKG_DEPENDS="libobjc2"

termux_step_pre_configure() {
	export OBJCXX="$CXX"
}
