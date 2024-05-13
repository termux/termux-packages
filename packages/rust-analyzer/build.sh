TERMUX_PKG_HOMEPAGE=https://github.com/rust-lang/rust-analyzer
TERMUX_PKG_DESCRIPTION="A Rust compiler front-end for IDEs"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20240513"
_VERSION=${TERMUX_PKG_VERSION:0:4}-${TERMUX_PKG_VERSION:4:2}-${TERMUX_PKG_VERSION:6:2}
TERMUX_PKG_SRCURL=https://github.com/rust-lang/rust-analyzer/archive/refs/tags/${_VERSION}.tar.gz
TERMUX_PKG_SHA256=1a02f0d55701ef270a091f800d45ab51ee0ed6e8e75f901f1d0959b2990625af
TERMUX_PKG_DEPENDS="rust-src"
TERMUX_PKG_ANTI_BUILD_DEPENDS="rust-src"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local e=0
	local api_url="https://api.github.com/repos/rust-lang/rust-analyzer/tags"
	local api_url_r=$(curl -s "${api_url}")
	local r1=$(echo "${api_url_r}" | jq .[].name | sed -e 's|\"||g')
	local latest_tag=$(echo "${r1}" | sed -nE 's/^([0-9]*-)/\1/p' | sort | tail -n1)
	# https://github.com/termux/termux-packages/issues/18667
	local latest_version=${latest_tag:0:4}${latest_tag:5:2}${latest_tag:8:2}
	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi
	[[ -z "${api_url_r}" ]] && e=1
	[[ -z "${r1}" ]] && e=1
	[[ -z "${latest_tag}" ]] && e=1
	[[ -z "${latest_version}" ]] && e=1

	if [[ "${e}" != 0 ]]; then
		cat <<- EOL >&2
		WARN: Auto update failure!
		api_url_r=${api_url_r}
		r1=${r1}
		latest_tag=${latest_tag}
		latest_version=${latest_version}
		EOL
		return
	fi

	if ! dpkg --compare-versions "${latest_version}" gt "${TERMUX_PKG_VERSION}"; then
		termux_error_exit "
		ERROR: Resulting latest version is not counted as an update!
		Latest version  = ${latest_version}
		Current version = ${TERMUX_PKG_VERSION}
		"
	fi

	termux_pkg_upgrade_version "${latest_version}" --skip-version-check
}

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "${TERMUX_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/rust-analyzer"
}
