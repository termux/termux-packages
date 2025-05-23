TERMUX_PKG_HOMEPAGE=https://sheldon.cli.rs/
TERMUX_PKG_DESCRIPTION="Fast, configurable, shell plugin manager"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.2"
TERMUX_PKG_SRCURL=https://github.com/rossmacarthur/sheldon/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b9306902849344bacb9525051c88b34487767086adc93936fdef98c8650cfc8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libssh2, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export LIBSSH2_SYS_USE_PKG_CONFIG=1
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin target/${CARGO_TARGET_NAME}/release/sheldon

	# completions
	install -Dm644 completions/sheldon.bash "${TERMUX_PREFIX}/share/bash-completion/completions/sheldon"
	install -Dm644 completions/sheldon.zsh "${TERMUX_PREFIX}/share/zsh/site-functions/_sheldon"
}
