TERMUX_PKG_HOMEPAGE=https://taskwarrior.org
TERMUX_PKG_DESCRIPTION="Utility for managing your TODO list"
TERMUX_PKG_VERSION=2.5.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://taskwarrior.org/download/task-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libgnutls, libuuid, libandroid-glob"
TERMUX_PKG_KEEP_SHARE_DOC=yes

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

