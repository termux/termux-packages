TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter
TERMUX_PKG_DESCRIPTION="An incremental parsing system for programming tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.25.9"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=024a2478579acebbb8882d7c2c0f0e07fc0aa19a459b48d10469e4abb96cf16e
TERMUX_PKG_BREAKS="libtreesitter"
TERMUX_PKG_REPLACES="libtreesitter"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" newest-tag)"

	# Is there a new release?
	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0.25

	# This blocks auto-updates to an incompatible SO version.
	if [[ "${latest_release}" != "${_SOVERSION}".* ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi

	# Figure out the new SHA256 for the `termux_setup_treesitter` function
	local TS_BIN_URL TS_TMPFILE NEW_TS_SHA256
	TS_BIN_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${latest_release}/tree-sitter-linux-x64.gz"
	TS_TMPFILE="$(mktemp)"
	curl -sL "$TS_BIN_URL" -o "$TS_TMPFILE"
	NEW_TS_SHA256=$(sha256sum "$TS_TMPFILE" | cut -d' ' -f1)

	sed \
		-e "s|\(^\s*\)local TERMUX_TREE_SITTER_SHA256=[0-9a-f]*|\1local TS_GZ_SHA256=${NEW_TS_SHA256}|" \
		-i "${TERMUX_SCRIPTDIR}/scripts/build/setup/termux_setup_treesitter.sh"

	termux_pkg_upgrade_version "${latest_release}"
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
