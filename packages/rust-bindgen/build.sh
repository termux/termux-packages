TERMUX_PKG_HOMEPAGE=https://github.com/rust-lang/rust-bindgen
TERMUX_PKG_DESCRIPTION="Automatically generates Rust FFI bindings to C (and some C++) libraries"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.72.1"
TERMUX_PKG_SRCURL=https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4ffb17061b2d71f19c5062d2e17e64107248f484f9775c0b7d30a16a8238dfd1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	local BUILD_TYPE=
	if [ $TERMUX_DEBUG_BUILD = false ]; then
		BUILD_TYPE=--release
	fi

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME ${BUILD_TYPE}
}

termux_step_make_install() {
	local BUILD_TYPE=release
	if [ $TERMUX_DEBUG_BUILD = true ]; then
		BUILD_TYPE=debug
	fi

	install -Dm755 -t $TERMUX_PREFIX/bin \
		target/${CARGO_TARGET_NAME}/${BUILD_TYPE}/bindgen
}
