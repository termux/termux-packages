TERMUX_PKG_HOMEPAGE=https://github.com/NuengCoder/ntc
TERMUX_PKG_DESCRIPTION="Navigate, Tree, Cat - CLI tool for directory navigation, tree viewing, and file concatenation"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_SRCURL=https://github.com/NuengCoder/ntc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1582609D70CDE7BE6E41F2F792082358D3F5105886D350D3E968AEC6E79F2DF9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" \
		"target/${CARGO_TARGET_NAME}/release/ntc"
}
