TERMUX_PKG_HOMEPAGE=https://github.com/zigtools/zls
TERMUX_PKG_DESCRIPTION="Zig language server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_SRCURL="https://github.com/zigtools/zls/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f77940720768daf67c01802ea3cf3029dfd8a74afd7b68b39676c4f814dd992e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_zig
	zig build -Dtarget="$ZIG_TARGET_NAME" -Doptimize=ReleaseSafe
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" zig-out/bin/zls
}
