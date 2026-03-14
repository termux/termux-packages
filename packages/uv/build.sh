TERMUX_PKG_HOMEPAGE=https://docs.astral.sh/uv/
TERMUX_PKG_DESCRIPTION="An extremely fast Python package installer and resolver, written in Rust."
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.10"
TERMUX_PKG_SRCURL=https://github.com/astral-sh/uv/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ba4082c92c97e0cc5ac0bc48a2783bc5026c8a14a768ecfb5f7012223a5e90ac
TERMUX_PKG_DEPENDS="zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust
}

termux_step_make() {
	PKG_CONFIG_ALL_DYNAMIC=1 \
	ZSTD_SYS_USE_PKG_CONFIG=1 \
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin target/"${CARGO_TARGET_NAME}"/release/uv
	install -Dm700 -t "${TERMUX_PREFIX}"/bin target/"${CARGO_TARGET_NAME}"/release/uvx
}

termux_step_post_make_install() {
	# Make a placeholder for shell-completions (to be filled with postinst)
	mkdir -p "${TERMUX_PREFIX}"/share/bash-completion/completions
	mkdir -p "${TERMUX_PREFIX}"/share/elvish/lib
	mkdir -p "${TERMUX_PREFIX}"/share/fish/vendor_completions.d
	mkdir -p "${TERMUX_PREFIX}"/share/zsh/site-functions
	touch "${TERMUX_PREFIX}"/share/bash-completion/completions/uv
	touch "${TERMUX_PREFIX}"/share/elvish/lib/uv.elv
	touch "${TERMUX_PREFIX}"/share/fish/vendor_completions.d/uv.fish
	touch "${TERMUX_PREFIX}"/share/zsh/site-functions/_uv
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh

		uv generate-shell-completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/uv"
		uv generate-shell-completion elvish > "$TERMUX_PREFIX/share/elvish/lib/uv.elv"
		uv generate-shell-completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/uv.fish"
		uv generate-shell-completion zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_uv"
	EOF
}
