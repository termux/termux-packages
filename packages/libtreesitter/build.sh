TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter
TERMUX_PKG_DESCRIPTION="An incremental parsing system for programming tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.7"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b355e968ec2d0241bbd96748e00a9038f83968f85d822ecb9940cbe4c42e182e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(sed -En 's/^SONAME_MAJOR\s*:?=\s*([0-9]+).*/\1/p' \
			Makefile)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_post_make_install() {
	termux_setup_rust

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release

	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/tree-sitter
}
