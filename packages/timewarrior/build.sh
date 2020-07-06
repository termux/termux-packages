TERMUX_PKG_HOMEPAGE=https://timewarrior.net/
TERMUX_PKG_DESCRIPTION="Command-line time tracker"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/GothenburgBitFactory/timewarrior/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6199304fc9697a2eb78c542357aec984924bc2ecad90f3bedf1f6299fe345484
TERMUX_PKG_DEPENDS="libandroid-glob, libc++"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

