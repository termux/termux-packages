TERMUX_PKG_HOMEPAGE=https://github.com/denisidoro/navi
TERMUX_PKG_DESCRIPTION="An interactive cheatsheet tool for the command-line"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.23.0"
TERMUX_PKG_SRCURL=https://github.com/denisidoro/navi/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=579a72814e7ba07dae697a58dc13b0f7d853532ec07229aff07a11e5828f3799
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fzf, git"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f Makefile
}

termux_step_make_install() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/navi
}
