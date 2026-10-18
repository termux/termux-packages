TERMUX_PKG_HOMEPAGE="https://github.com/kristoff-it/superhtml"
TERMUX_PKG_DESCRIPTION="A HTML language server and templating engine formatter/linter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="git+https://github.com/kristoff-it/superhtml"
TERMUX_PKG_GIT_BRANCH="main"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_zig

	zig build \
		-Dtarget="${ZIG_TARGET_NAME}" \
		-Doptimize=ReleaseSafe
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" zig-out/bin/superhtml
}
