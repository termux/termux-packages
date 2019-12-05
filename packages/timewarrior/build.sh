TERMUX_PKG_HOMEPAGE=https://taskwarrior.org/docs/timewarrior/
TERMUX_PKG_DESCRIPTION="Command-line time tracker"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=https://github.com/GothenburgBitFactory/timewarrior/releases/download/v$TERMUX_PKG_VERSION/timew-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2c4d153105a32536ae328038246ebd846a5abd96df7ed29c11100866eaed8e3c
TERMUX_PKG_DEPENDS="libandroid-glob, libc++"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

