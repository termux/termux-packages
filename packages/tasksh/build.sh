TERMUX_PKG_HOMEPAGE=https://taskwarrior.org
TERMUX_PKG_DESCRIPTION="Shell command wrapping Taskwarrior commands"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=http://taskwarrior.org/download/tasksh-latest.tar.gz
TERMUX_PKG_SHA256=6e42f949bfd7fbdde4870af0e7b923114cc96c4344f82d9d924e984629e21ffd
TERMUX_PKG_DEPENDS="readline, taskwarrior, libandroid-glob"
TERMUX_PKG_FOLDERNAME=tasksh-$TERMUX_PKG_VERSION

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

