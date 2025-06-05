TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter
TERMUX_PKG_DESCRIPTION="An incremental parsing system for programming tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.25.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ac6ed919c6d849e8553e246d5cd3fa22661f6c7b6497299264af433f3629957c
TERMUX_PKG_BREAKS="libtreesitter"
TERMUX_PKG_REPLACES="libtreesitter"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0.25

	# This blocks auto-updates to an incompatible SO version.
	if [[ "$TERMUX_PKG_VERSION" != "${_SOVERSION}".* ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	termux_setup_rust
	# clash with rust host build
	# causes 32bit builds to fail if set
	unset CFLAGS
}

termux_step_post_make_install() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
	install -Dm700 -t "$TERMUX_PREFIX"/bin target/"${CARGO_TARGET_NAME}"/release/tree-sitter

	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"
	mkdir -p "${TERMUX_PREFIX}/share/nushell/vendor/autoload"
	cargo run -- complete --shell     zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	cargo run -- complete --shell    bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	cargo run -- complete --shell    fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	cargo run -- complete --shell  elvish > "${TERMUX_PREFIX}/share/elvish/lib/${TERMUX_PKG_NAME}.elv"
	cargo run -- complete --shell nushell > "${TERMUX_PREFIX}/share/nushell/vendor/autoload/${TERMUX_PKG_NAME}.nu"
}
