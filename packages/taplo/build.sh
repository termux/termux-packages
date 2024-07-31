TERMUX_PKG_HOMEPAGE=https://taplo.tamasfe.dev/
TERMUX_PKG_DESCRIPTION="A TOML LSP and toolkit"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.9.3"
TERMUX_PKG_SRCURL=https://github.com/tamasfe/taplo/archive/refs/tags/release-taplo-cli-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5744a06a1e93128f5cb5409d5bf5e553915703ec0491df9f4c7ab31dbe430287
TERMUX_PKG_BUILD_DEPENDS='openssl'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='release-taplo-cli-\([0-9]*\.[0-9]*\.[0-9]*\)'

termux_pkg_auto_update() {
	# Get latest release tag:
	local api_url="https://api.github.com/repos/tamasfe/taplo/git/refs/tags"
	local latest_refs_tags
	latest_refs_tags=$(curl -s "${api_url}" | jq '.[].ref' | sed -ne "s|.*${TERMUX_PKG_UPDATE_VERSION_REGEXP}\"|\1|p")
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi

	local latest_version
	latest_version=$(tail -n1 <<< "$latest_refs_tags")
	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	# We want to avoid re-filtering the version.
	# It's already cleaned up, so unset the regexp.
	# See: https://github.com/termux/termux-packages/issues/20836
	unset TERMUX_PKG_UPDATE_VERSION_REGEXP

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--all-features
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX"/bin target/"$CARGO_TARGET_NAME"/release/taplo
}
