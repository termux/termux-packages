TERMUX_PKG_HOMEPAGE=https://github.com/mozilla/geckodriver
TERMUX_PKG_DESCRIPTION="Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.36.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mozilla/geckodriver/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=03d8fe48d32a711318b2fffc93019874731318de44f36a9731935d10bdea762b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RECOMMENDS="firefox"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --bin geckodriver --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/geckodriver
	ln -sf $TERMUX_PREFIX/bin/geckodriver $TERMUX_PREFIX/bin/wires
}
