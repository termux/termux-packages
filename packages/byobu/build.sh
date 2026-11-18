TERMUX_PKG_HOMEPAGE=https://www.byobu.org/
TERMUX_PKG_DESCRIPTION="Byobu is a GPLv3 open source text-based window manager and terminal multiplexer"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.24"
TERMUX_PKG_SRCURL="https://github.com/dustinkirkland/byobu/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=84151a9034070cb43de07642eeb37c2f60f8952c3b83526a9e1af1ec86dd4d39
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+(?!rc)'
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="gawk, tmux"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fiv
}
