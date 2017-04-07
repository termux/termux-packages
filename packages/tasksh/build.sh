TERMUX_PKG_HOMEPAGE=https://taskwarrior.org
TERMUX_PKG_DESCRIPTION="Shell command wrapping Taskwarrior commands"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://taskwarrior.org/download/tasksh-latest.tar.gz
TERMUX_PKG_SHA256=eef7c6677d6291b1c0e13595e8c9606d7f8dc1060d197a0d088cc1fddcb70024
TERMUX_PKG_DEPENDS="readline, taskwarrior, libandroid-glob"
TERMUX_PKG_FOLDERNAME=tasksh-$TERMUX_PKG_VERSION

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

