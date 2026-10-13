TERMUX_PKG_HOMEPAGE=https://github.com/tgraf/bmon
TERMUX_PKG_DESCRIPTION="Bandwidth monitor and rate estimator"
TERMUX_PKG_LICENSE="MIT, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.MIT, LICENSE.BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0
TERMUX_PKG_SRCURL=https://github.com/tgraf/bmon/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cd7f5fb366a8c32c0e33c79a5daae78edd273993d0edf1036638f269400cf012
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libconfuse, libnl, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
