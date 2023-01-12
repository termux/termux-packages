TERMUX_PKG_HOMEPAGE=https://asciinema.org/
TERMUX_PKG_DESCRIPTION="Record and share your terminal sessions, the right way"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/asciinema/asciinema/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cce6f0ed6bcf47d54fe5caae14862bfb5a2e39eec1b3b467a8ed1050c298d0ec
TERMUX_PKG_AUTO_UPDATE=true
# ncurses-utils for tput which asciinema uses:
TERMUX_PKG_DEPENDS="python, ncurses-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

termux_step_make() {
	return
}
