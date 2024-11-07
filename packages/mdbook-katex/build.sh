TERMUX_PKG_HOMEPAGE=https://github.com/lzanini/mdbook-katex
TERMUX_PKG_DESCRIPTION="A preprocessor for mdBook, pre-rendering LaTex equations to HTML at build time"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.1"
TERMUX_PKG_SRCURL=https://github.com/lzanini/mdbook-katex/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9b976a073e46b60af4e62e216304e51c1e98b26942a6dd8c020e861c87fcba16
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+$"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local latest_tag="$(termux_github_api_get_tag \
		"${TERMUX_PKG_SRCURL}" latest-regex "${TERMUX_PKG_UPDATE_VERSION_REGEXP}")"
	if [[ -z "${latest_tag}" ]]; then
		termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	fi
	termux_pkg_upgrade_version "${latest_tag}"
}

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-katex
}
