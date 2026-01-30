TERMUX_PKG_HOMEPAGE=https://github.com/EmmyLuaLs/emmylua-analyzer-rust
TERMUX_PKG_DESCRIPTION="Emmy Lua Language Server coded in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Steven Xu @stevenxxiu"
TERMUX_PKG_VERSION="0.20.0"
TERMUX_PKG_SRCURL=https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5ddee74a31e63598ec619b73c483ab8d66c126f89b28447014d0e012bab57d1e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	# ld.lld: error: undefined symbol: __atomic_load_8
	if [[ "$TERMUX_ARCH" == "i686" ]]; then
		local -u env_host="${CARGO_TARGET_NAME//-/_}"
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	fi
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/emmylua_ls
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/emmylua_doc_cli
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/emmylua_check
}
