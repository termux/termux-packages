TERMUX_PKG_HOMEPAGE=https://github.com/loichyan/nerdfix
TERMUX_PKG_DESCRIPTION="nerdfix helps you to find/fix obsolete Nerd Font icons in your project."
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.4.1
TERMUX_PKG_SRCURL=https://github.com/loichyan/nerdfix/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=37f13ccf0eb6567b31862bc46e694a60177cbf5b76667fe73f22cef8f7ea68df
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag

termux_step_pre_configure() {
	# do not pin the version of the rust toolchain
	rm -f rust-toolchain.toml
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/nerdfix
}
