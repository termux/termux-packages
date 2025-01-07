TERMUX_PKG_HOMEPAGE="https://github.com/jblindsay/whitebox-tools"
TERMUX_PKG_DESCRIPTION="An advanced geospatial data analysis platform"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.0"
TERMUX_PKG_SRCURL="https://github.com/jblindsay/whitebox-tools/archive/refs/tags/v2.0.0.tar.gz"
TERMUX_PKG_SHA256=18705fc948bdb2f96cd816e5a72d36b9cc460aa8c910383d23fdbd61641aab60
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo update # Fix rust 1.73 incompatibility - can probably be removed when bumping version
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin/whitebox_tools  \
		target/${CARGO_TARGET_NAME}/release/whitebox_tools
}
