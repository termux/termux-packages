TERMUX_PKG_HOMEPAGE=https://www.byobu.org/
TERMUX_PKG_DESCRIPTION="Byobu is a GPLv3 open source text-based window manager and terminal multiplexer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.15"
TERMUX_PKG_SRCURL="https://github.com/dustinkirkland/byobu/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2d670627aeb068447654b78fd83901ea4b0d08df59f6fa0721d61cb1fc2f56ae
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="gawk, tmux"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fiv
}
