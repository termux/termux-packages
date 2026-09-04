TERMUX_PKG_HOMEPAGE=https://codeberg.org/jpt/jellyfish
TERMUX_PKG_DESCRIPTION="Library for approximate and phonetic matching of strings"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.2.1"
TERMUX_PKG_SRCURL="https://codeberg.org/jpt/jellyfish/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=77c42fd157719587509c5921ca81c7e1531f0e2771b1c9e7cebc470c2abd5c6d
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
	local _JF_SO
	_JF_SO=$(find \
		"${TERMUX_PREFIX}/lib/python${TERMUX_PYTHON_VERSION}/site-packages/jellyfish" \
		-maxdepth 1 -name "_rustyfish*.so")
	if [ -z "${_JF_SO}" ]; then
		termux_error_exit "Could not find built jellyfish extension module"
	fi
	patchelf --add-needed libpython${TERMUX_PYTHON_VERSION}.so "${_JF_SO}"
}
