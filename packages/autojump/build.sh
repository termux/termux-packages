TERMUX_PKG_HOMEPAGE=https://github.com/wting/autojump
TERMUX_PKG_DESCRIPTION="A faster way to navigate your filesystem"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=22.5.3
TERMUX_PKG_SRCURL=https://github.com/wting/autojump/archive/refs/tags/release-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=00daf3698e17ac3ac788d529877c03ee80c3790472a85d0ed063ac3a354c37b1
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	SHELL=/bin/bash ./install.py --system
}
