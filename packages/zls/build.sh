TERMUX_PKG_HOMEPAGE=https://github.com/zigtools/zls
TERMUX_PKG_DESCRIPTION="Zig language server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.13.0"
TERMUX_PKG_SRCURL="https://github.com/zigtools/zls/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2e8046b6b0de765a4bf4bb828345e2badc8b828bc257dc931d0f56b147684d9f
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_zig
	zig build -Dtarget=$ZIG_TARGET_NAME -Doptimize=ReleaseSafe
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin zig-out/bin/zls
}
