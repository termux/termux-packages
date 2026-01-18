TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/units/
TERMUX_PKG_DESCRIPTION="Converts between different systems of units"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.25"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/units/units-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=36edf43ac00b4d6304baea91387e65ab05118bf65c921f73d3b08828e5a6ec0b
TERMUX_PKG_DEPENDS="readline, libandroid-support"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sharedstatedir=$TERMUX_PREFIX/var/lib
"
