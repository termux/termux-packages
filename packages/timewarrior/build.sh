TERMUX_PKG_HOMEPAGE=https://tasktools.org/projects/timewarrior.html
TERMUX_PKG_DESCRIPTION="Command-line time tracker"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://taskwarrior.org/download/timew-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ac027910e1e8365bdd218a8b42389b26d017d38d3c96516c408db6d5a44e0bb5
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

