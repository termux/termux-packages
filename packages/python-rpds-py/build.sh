TERMUX_PKG_HOMEPAGE=https://github.com/crate-py/rpds
TERMUX_PKG_DESCRIPTION="Python bindings to Rust's persistent data structures (rpds)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2026.6.3"
TERMUX_PKG_SRCURL="https://github.com/crate-py/rpds/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e06265bb7b0818fe239f0c4ebb9b82132d22e2150a78456b345af17e3b8a86cc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="maturin"

termux_step_make_install() {
	termux_setup_rust
	export CARGO_BUILD_TARGET="${CARGO_TARGET_NAME}"
	export PYO3_CROSS_LIB_DIR="${TERMUX_PREFIX}/lib"
	export ANDROID_API_LEVEL="$TERMUX_PKG_API_LEVEL"
	pip install --no-build-isolation --no-deps . --prefix $TERMUX_PREFIX
}

termux_step_post_make_install() {
	local _RPDS_SO
	_RPDS_SO=$(find \
		"${TERMUX_PREFIX}/lib/python${TERMUX_PYTHON_VERSION}/site-packages/rpds" \
		-maxdepth 1 -name "*.so")
	if [ -z "${_RPDS_SO}" ]; then
		termux_error_exit "Could not find built rpds extension module"
	fi
	patchelf --add-needed libpython${TERMUX_PYTHON_VERSION}.so "${_RPDS_SO}"
}
