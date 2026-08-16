TERMUX_PKG_HOMEPAGE=https://www.byobu.org/
TERMUX_PKG_DESCRIPTION="Byobu is a GPLv3 open source text-based window manager and terminal multiplexer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.18"
TERMUX_PKG_SRCURL="https://github.com/dustinkirkland/byobu/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ba8613021de40ec81a26d8cf200e34c547f0de5db9f96ae20a6d28c9881af9e3
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+(?!rc)'
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="gawk, tmux"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fiv
}
