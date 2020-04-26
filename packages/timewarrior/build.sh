TERMUX_PKG_HOMEPAGE=https://timewarrior.net/
TERMUX_PKG_DESCRIPTION="Command-line time tracker"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_SRCURL=https://github.com/GothenburgBitFactory/timewarrior/releases/download/v$TERMUX_PKG_VERSION/timew-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1f3b9166a96637d3c098a7cfcff74ca61c41f13e2ca21f6c7ad6dd54cc74ac70
TERMUX_PKG_DEPENDS="libandroid-glob, libc++"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

