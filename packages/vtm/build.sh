TERMUX_PKG_HOMEPAGE=https://vtm.netxs.online/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.8v"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/netxs-group/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9ce261ef725bf96dc76cd2df364ea0573db6bac083ceae192ccc5414ce0b6399
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+=/src
	CXXFLAGS+=" -pthread"
	LDFLAGS+=" -landroid-spawn"
}
