TERMUX_PKG_HOMEPAGE=https://taskwarrior.org
TERMUX_PKG_DESCRIPTION="Shell command wrapping Taskwarrior commands"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://taskwarrior.org/download/tasksh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6e42f949bfd7fbdde4870af0e7b923114cc96c4344f82d9d924e984629e21ffd
TERMUX_PKG_DEPENDS="readline, taskwarrior, libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

