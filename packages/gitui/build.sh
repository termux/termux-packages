TERMUX_PKG_HOMEPAGE=https://github.com/extrawurst/gitui
TERMUX_PKG_DESCRIPTION="Blazing fast terminal-ui for git written in rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@PeroSar"
TERMUX_PKG_VERSION=0.20.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/extrawurst/gitui/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=eccec120dfd4c5c33a74d331a53f3d0c6cb7200e26b0c4c7873278eb951bc379
TERMUX_PKG_DEPENDS="git, zlib, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_NO_VENDOR=1
}

termux_step_make() {
	termux_setup_rust

	cargo build --release \
		--jobs "$TERMUX_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--locked
}

termux_step_make_install() {
	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/gitui "$TERMUX_PREFIX"/bin/
}
