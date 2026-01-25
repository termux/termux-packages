TERMUX_PKG_HOMEPAGE=https://tree-sitter.github.io/
TERMUX_PKG_DESCRIPTION="An incremental parsing system for programming tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.25.10"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ad5040537537012b16ef6e1210a572b927c7cdc2b99d1ee88d44a7dcdc3ff44c
TERMUX_PKG_BREAKS="libtreesitter"
TERMUX_PKG_REPLACES="libtreesitter"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?!-)"
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(termux_github_api_get_tag)"

	if ! latest_release="$(grep --max-count=1 -oP "${TERMUX_PKG_UPDATE_VERSION_REGEXP}" <<< "${latest_release}")"; then
		echo "INFO: Tag '${latest_release}' does not look like a stable version."
		return
	fi

	# Is there a new release?
	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_release}."
		return
	fi

	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0.25

	# This blocks auto-updates to an incompatible SO version.
	if [[ "${latest_release}" != "${_SOVERSION}".* ]]; then
		echo "Latest release is '${latest_release}'" >&2
		termux_error_exit "SOVERSION guard check failed."
	fi

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_release}."
		return
	fi

	# Figure out the new SHA256 for the `termux_setup_treesitter` function
	local TS_BIN_URL TS_TMPFILE NEW_TS_SHA256
	TS_BIN_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${latest_release}/tree-sitter-linux-x64.gz"
	TS_TMPFILE="$(mktemp)"
	curl -sL "$TS_BIN_URL" -o "$TS_TMPFILE"
	NEW_TS_SHA256="$(sha256sum "$TS_TMPFILE" | cut -d' ' -f1)"

	sed \
		-e "s|\(^\s*\)local TERMUX_TREE_SITTER_SHA256=[0-9a-f]*|\1local TERMUX_TREE_SITTER_SHA256=${NEW_TS_SHA256}|" \
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
