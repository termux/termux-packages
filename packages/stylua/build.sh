TERMUX_PKG_HOMEPAGE=https://github.com/JohnnyMorganz/StyLua
TERMUX_PKG_DESCRIPTION="An opinionated Lua code formatter"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.0"
TERMUX_PKG_SRCURL=https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f4a27b12669953d2edf55b89cc80381f97a2dfa735f53f95c6ae6015c8c35ffb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --all-features

}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/stylua
}
