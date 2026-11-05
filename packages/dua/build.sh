TERMUX_PKG_HOMEPAGE=https://github.com/Byron/dua-cli
TERMUX_PKG_DESCRIPTION="View disk space usage and delete unwanted data, fast"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.0"
TERMUX_PKG_SRCURL=https://github.com/Byron/dua-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d178e30610b29b23b2ec478bb4ba256a01b82c8497895693e6cd92682bfcd4bd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='v\d+\.\d+\.\d+'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release --no-default-features --features tui-crossplatform
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX"/bin target/"${CARGO_TARGET_NAME}"/release/dua
}
