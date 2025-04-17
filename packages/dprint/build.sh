TERMUX_PKG_HOMEPAGE=https://dprint.dev/
TERMUX_PKG_DESCRIPTION="Pluggable and configurable code formatting platform written in Rust."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.49.1"
TERMUX_PKG_SRCURL="https://github.com/dprint/dprint/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=df019b295ff137ccaec3ad8c7a39282b485b6381ff5a3519ec18bd3d7c89ba72
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/dprint"
}
