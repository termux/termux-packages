TERMUX_PKG_HOMEPAGE=https://github.com/zigtools/zls
TERMUX_PKG_DESCRIPTION="Zig language server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.16.0"
TERMUX_PKG_SRCURL="https://github.com/zigtools/zls/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e7c5936f5b3a057ce851be0876e4e259b5c4d02f9aae038cd24a5d6b586b029f
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_zig
	zig build -Dtarget="$ZIG_TARGET_NAME" -Doptimize=ReleaseSafe
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" zig-out/bin/zls
}
