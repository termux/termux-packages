TERMUX_PKG_HOMEPAGE=https://github.com/pipeseroni/pipes.sh
TERMUX_PKG_DESCRIPTION="Animated pipes terminal screensaver"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Efreak"
TERMUX_PKG_VERSION=1.3.0+ #if there's ever a new release, switch to it
TERMUX_PKG_SRCURL=https://github.com/pipeseroni/pipes.sh/archive/refs/heads/master.zip # in the meantime, master has a bunch of changes
TERMUX_PKG_SHA256=2a606f57e7029c4a1f0317045ed078aa37b463cc1871d36e3e0e6f4aa130a9f8
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS=bash

termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR"
	make install PREFIX=$TERMUX_PREFIX
}
