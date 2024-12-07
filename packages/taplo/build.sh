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
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d\.\d\.\d'

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags https://github.com/tamasfe/taplo.git \
	| grep -oP "refs/tags/release-taplo-cli-\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
	| sort -V \
	| tail -n1)"

	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
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
