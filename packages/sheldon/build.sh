TERMUX_PKG_HOMEPAGE=https://github.com/rossmacarthur/sheldon
TERMUX_PKG_DESCRIPTION="Fast, configurable, shell plugin manager"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.6
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/rossmacarthur/sheldon/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d6cdc8fe011c4defe65fbe1507e48a51f8efdeebb5d5b0b39fbde2c73566973
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin target/${CARGO_TARGET_NAME}/release/sheldon

	# completions
	install -Dm644 completions/sheldon.bash "${TERMUX_PREFIX}/share/bash-completion/completions/sheldon"
	install -Dm644 completions/sheldon.zsh "${TERMUX_PREFIX}/share/zsh/site-functions/_sheldon"
}
