TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter
TERMUX_PKG_DESCRIPTION="An incremental parsing system for programming tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.24.2"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=199da041ac7ef62bccdda9b7bec28aafa073f7eea2677680aa7992d503c9cc64
TERMUX_PKG_BREAKS="libtreesitter"
TERMUX_PKG_REPLACES="libtreesitter"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0.24

	# New SO version is the major version of the package
	if [[ $TERMUX_PKG_VERSION != $_SOVERSION.* ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_post_make_install() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release

	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/tree-sitter
}
