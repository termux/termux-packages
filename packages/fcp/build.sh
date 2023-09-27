TERMUX_PKG_HOMEPAGE=https://github.com/Svetlitski/fcp
TERMUX_PKG_DESCRIPTION="A significantly faster alternative to the classic Unix cp(1) command"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.1
TERMUX_PKG_SRCURL=git+https://github.com/Svetlitski/fcp
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/fcp
}
