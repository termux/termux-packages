TERMUX_PKG_HOMEPAGE=https://github.com/zigtools/zls
TERMUX_PKG_DESCRIPTION="Zig language server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@SunPodder"
TERMUX_PKG_VERSION=0.11.0
TERMUX_PKG_SRCURL="https://github.com/zigtools/zls/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=09fee5720fed9f3e1f494236ba88bf9176d3a01304feaa355b9f4726a574431b
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_zig
	zig build -Dtarget=$ZIG_TARGET_NAME -Doptimize=ReleaseSafe
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin zig-out/bin/zls
}
