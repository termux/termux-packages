TERMUX_PKG_HOMEPAGE=https://sarnold.github.io/cccc/
TERMUX_PKG_DESCRIPTION="Source code counter and metrics tool for C++, C, and Java"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@xploitednoob"
TERMUX_PKG_VERSION=3.1.6
TERMUX_PKG_SRCURL=https://github.com/sarnold/cccc/archive/refs/tags/${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=bb57fda1520fa83c6f51a886b34f1076938c05fe1fe260465757190de3b707fc
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_make() {
	make cccc
}
termux_step_make_install() {
	#Copy binary
	mkdir -p "$TERMUX_PREFIX/bin"
        install -Dm755 cccc/cccc "$TERMUX_PREFIX/bin"
}
