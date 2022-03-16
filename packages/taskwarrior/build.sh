TERMUX_PKG_HOMEPAGE=https://taskwarrior.org
TERMUX_PKG_DESCRIPTION="Utility for managing your TODO list"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.2
TERMUX_PKG_SRCURL=https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${TERMUX_PKG_VERSION}/task-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b1d3a7f000cd0fd60640670064e0e001613c9e1cb2242b9b3a9066c78862cfec
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libgnutls, libuuid, libandroid-glob"
TERMUX_CMAKE_BUILD="Unix Makefiles"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

