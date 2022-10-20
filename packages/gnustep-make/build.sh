TERMUX_PKG_HOMEPAGE=http://www.gnustep.org
TERMUX_PKG_DESCRIPTION="The GNUstep makefile package"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.9.0
TERMUX_PKG_SRCURL=https://github.com/gnustep/tools-make/archive/make-${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=f7c69bea7f26ca5d4ce6ad82fbe94d2405cf238d652ea608fe387a70a5e0232c
TERMUX_PKG_DEPENDS="libobjc2"

termux_step_pre_configure() {
	export OBJCXX="$CXX"
}
