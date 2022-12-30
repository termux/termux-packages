TERMUX_PKG_HOMEPAGE=https://github.com/nivekuil/rip
TERMUX_PKG_DESCRIPTION="A command-line deletion tool focused on safety, ergonomics, and performance"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.13.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/nivekuil/rip
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rip
}
