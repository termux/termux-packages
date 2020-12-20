TERMUX_PKG_HOMEPAGE=https://taskwarrior.org
TERMUX_PKG_DESCRIPTION="Utility for managing your TODO list"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.1
TERMUX_PKG_REVISION=9
TERMUX_PKG_SRCURL=https://taskwarrior.org/download/task-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d87bcee58106eb8a79b850e9abc153d98b79e00d50eade0d63917154984f2a15
TERMUX_PKG_DEPENDS="libc++, libgnutls, libuuid, libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

