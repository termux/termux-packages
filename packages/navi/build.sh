TERMUX_PKG_HOMEPAGE=https://github.com/denisidoro/navi
TERMUX_PKG_DESCRIPTION="An interactive cheatsheet tool for the command-line"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.16.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/denisidoro/navi/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f4767e4ad833c16be556d690b2cac0c9bf0a3ddfc4b782a832f6f1f1c3add9c0
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f Makefile
}

termux_step_make_install() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/navi
}
