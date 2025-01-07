TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/bat
TERMUX_PKG_DESCRIPTION="A cat(1) clone with wings"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.24.0"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/sharkdp/bat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=907554a9eff239f256ee8fe05a922aad84febe4fe10a499def72a4557e9eedfb
TERMUX_PKG_AUTO_UPDATE=true
# bat calls less with '--RAW-CONTROL-CHARS' which busybox less does not support:
TERMUX_PKG_DEPENDS="less, libgit2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export CFLAGS_${CARGO_TARGET_NAME//-/_}+=" -Dindex=strchr"

	# See https://github.com/nagisa/rust_libloading/issues/54
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu=""

	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local f
	for f in $CARGO_HOME/registry/src/*/libgit2-sys-*/build.rs; do
		sed -i -E 's/\.range_version\(([^)]*)\.\.[^)]*\)/.atleast_version(\1)/g' "${f}"
	done
}

termux_step_post_make_install() {
	find . -name bat.1 -type f -exec install -Dm644 {} "$TERMUX_PREFIX/share/man/man1/bat.1" \;
	find . -name bat.bash -type f -exec install -Dm644 {} "$TERMUX_PREFIX/share/bash-completion/completions/bat" \;
	find . -name bat.zsh -type f -exec install -Dm644 {} "$TERMUX_PREFIX/share/zsh/site-functions/_bat" \;
	find . -name bat.fish -type f -exec install -Dm644 {} "$TERMUX_PREFIX/share/fish/vendor_completions.d/bat.fish" \;
}
