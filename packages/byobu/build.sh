TERMUX_PKG_HOMEPAGE=https://www.byobu.org/
TERMUX_PKG_DESCRIPTION="Byobu is a GPLv3 open source text-based window manager and terminal multiplexer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.13"
TERMUX_PKG_SRCURL=https://github.com/dustinkirkland/byobu/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9690c629588e8f95d16b2461950d39934faaf8005dd2a283886d4e3bd6c86df6
TERMUX_PKG_DEPENDS="gawk, tmux"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fiv
}
