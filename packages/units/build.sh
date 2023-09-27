TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/units/
TERMUX_PKG_DESCRIPTION="Converts between different systems of units"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.22
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/units/units-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d13e1207721fe7726d906ba1d92dc0eddaa9fc26759ed22e3b8d1a793125848
TERMUX_PKG_DEPENDS="readline, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sharedstatedir=$TERMUX_PREFIX/var/lib
"
