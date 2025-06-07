TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter
TERMUX_PKG_DESCRIPTION="An incremental parsing system for programming tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.25.6"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ac6ed919c6d849e8553e246d5cd3fa22661f6c7b6497299264af433f3629957c
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

	# Figure out the new SHA256 for the `tree-sitter-cross-tools` release file.
	local TS_GZ_URL TS_GZFILE NEW_TS_SHA256
	TS_GZ_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${latest_release}/tree-sitter-linux-x64.gz"
	TS_GZFILE="$(mktemp)"
	curl -sL "$TS_GZ_URL" -o "$TS_GZFILE"
	NEW_TS_SHA256=$(sha256sum "${TS_GZFILE}" | cut -d' ' -f1)

	local TS_GZ_SHA256=c300ea9f2ca368186ce1308793aaad650c3f6db78225257cbb5be961aeff4038

	if [[ "$NEW_TS_SHA256" != "$TS_GZ_SHA256" ]]; then
		echo "Need to update SHA256 sum for tree-sitter-host-tools"
		echo "-$TS_GZ_SHA256"
		echo "+$NEW_TS_SHA256"
		sed \
			-e "s|local TS_GZ_SHA256=${TS_GZ_SHA256}|local TS_GZ_SHA256=${NEW_TS_SHA256}|" \
			-i "${TERMUX_SCRIPTDIR}/packages/tree-sitter/build.sh"
	fi

	termux_pkg_upgrade_version "${latest_release}"
}

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0.25

	# This blocks auto-updates to an incompatible SO version.
	if [[ "$TERMUX_PKG_VERSION" != "${_SOVERSION}".* ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi

	local TS_GZ_SHA256=c300ea9f2ca368186ce1308793aaad650c3f6db78225257cbb5be961aeff4038
	termux_download \
		https://github.com/tree-sitter/tree-sitter/releases/download/v${TERMUX_PKG_VERSION}/tree-sitter-linux-x64.gz \
		"$TERMUX_PKG_CACHEDIR"/tree-sitter-linux-x64.gz \
		"$TS_GZ_SHA256"
	gunzip -k -v "$TERMUX_PKG_CACHEDIR"/tree-sitter-linux-x64.gz
	mv -v "$TERMUX_PKG_CACHEDIR"/{tree-sitter-linux-x64,tree-sitter}
	install -Dm700 -t "$TERMUX_PREFIX"/opt/tree-sitter/cross/bin "$TERMUX_PKG_CACHEDIR"/tree-sitter
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
