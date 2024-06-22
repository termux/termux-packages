TERMUX_PKG_HOMEPAGE=https://github.com/loichyan/nerdfix
TERMUX_PKG_DESCRIPTION="nerdfix helps you to find/fix obsolete Nerd Font icons in your project."
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_SRCURL=https://github.com/loichyan/nerdfix/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=72e835aeb349495be87e92f74f405b43dac982ec137cfd7e180e72146b6f6fb7
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# do not pin the version of the rust toolchain
	rm -f rust-toolchain
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/nerdfix
}
