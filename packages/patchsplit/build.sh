TERMUX_PKG_HOMEPAGE=https://github.com/zitzhen/patchsplit
TERMUX_PKG_DESCRIPTION="A CLI tool for splitting patch files into per-commit patches"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Iamliuxiaozhen"
TERMUX_PKG_VERSION="1.3.1"
TERMUX_PKG_SRCURL="https://github.com/zitzhen/patchsplit/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1bdbfc880b892acd73dca6529abd7e80a122774348e8e075e158011b52d869a2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release
}

termux_step_make_install() {
	install -Dm755 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME/release/patchsplit" \
		"$TERMUX_PREFIX/bin/patchsplit"
}