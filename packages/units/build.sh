TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/units/
TERMUX_PKG_DESCRIPTION="Converts between different systems of units"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.24"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/units/units-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1e502c4edfacf20b29284716c72e5ddb51a495a2365d7b03e7960494c4a0c902
TERMUX_PKG_DEPENDS="readline, libandroid-support"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sharedstatedir=$TERMUX_PREFIX/var/lib
"
