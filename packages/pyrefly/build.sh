TERMUX_PKG_HOMEPAGE=https://github.com/facebook/pyrefly.git
TERMUX_PKG_DESCRIPTION="A fast type checker and language server for Python"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@AhmadNaruto"
TERMUX_PKG_VERSION="0.36.0"
TERMUX_PKG_SRCURL="https://github.com/facebook/pyrefly/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4f4205ce4b29a3ec3d32a8a920997c99ced843ab72d58fde679b017df0db547b
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release  --locked
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/pyrefly
}
