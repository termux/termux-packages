TERMUX_PKG_HOMEPAGE=https://github.com/denisidoro/navi
TERMUX_PKG_DESCRIPTION="An interactive cheatsheet tool for the command-line"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.20.0"
TERMUX_PKG_SRCURL=https://github.com/denisidoro/navi/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=60e3fafed0b6fc17cc8174420e44d1fe6b5779be456da631ea1f1565cc640a14
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fzf, git"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f Makefile
}

termux_step_make_install() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/navi
}
