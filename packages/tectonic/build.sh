TERMUX_PKG_HOMEPAGE=https://tectonic-typesetting.github.io/
TERMUX_PKG_DESCRIPTION="A modernized, complete, self-contained TeX/LaTeX engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.0"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=git+https://github.com/tectonic-typesetting/tectonic
TERMUX_PKG_GIT_BRANCH=tectonic@${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="fontconfig, freetype, libc++, libgraphite, libicu, libpng, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	# Get latest release tag:
	local api_url="https://api.github.com/repos/tectonic-typesetting/tectonic/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | sed -ne "s|.*tectonic@\(.*\)\"|\1|p")
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi

	local latest_version=$(echo "${latest_refs_tags}" | tail -n1)
	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/tectonic
}
