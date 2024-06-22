TERMUX_PKG_HOMEPAGE=https://byobu.co/
TERMUX_PKG_DESCRIPTION="Byobu is a GPLv3 open source text-based window manager and terminal multiplexer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.12"
TERMUX_PKG_SRCURL=https://github.com/dustinkirkland/byobu/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=abb000331858609dfda9214115705506249f69237625633c80487abe2093dd45
TERMUX_PKG_DEPENDS="gawk, tmux"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fiv
}
