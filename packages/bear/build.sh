TERMUX_PKG_HOMEPAGE=https://github.com/rizsotto/Bear
TERMUX_PKG_DESCRIPTION="Bear is a tool that generates a compilation database for clang tooling."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Nguyen Khanh @nguynkhn"
TERMUX_PKG_VERSION="4.2.3"
TERMUX_PKG_SRCURL="https://github.com/rizsotto/Bear/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7c3901786f01da60d606cc80afdda36e866259b78e1dd7f890fd42cee64d3574
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release
}

termux_step_make_install() {
	rm -rf target/release
	mv "target/$CARGO_TARGET_NAME/release" target/release
	scripts/install.sh
}
