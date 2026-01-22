TERMUX_PKG_HOMEPAGE=https://github.com/pyca/cryptography
TERMUX_PKG_DESCRIPTION="Provides cryptographic recipes and primitives to Python developers"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.APACHE, LICENSE.BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="46.0.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/pyca/cryptography/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7571f0e09a6d6eb22168993f94d35867b4dcbd0d34224e0eb7b392b905b3f12f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, python, python-pip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="maturin, 'cffi>=1.12'"
TERMUX_PKG_PYTHON_TARGET_DEPS="'cffi>=1.12'"

termux_step_configure() {
	termux_setup_rust
	export CARGO_BUILD_TARGET="${CARGO_TARGET_NAME}"
	export PYO3_CROSS_LIB_DIR="${TERMUX_PREFIX}/lib"
	export ANDROID_API_LEVEL="${TERMUX_PKG_API_LEVEL}"
}

termux_step_make_install() {
	# Needed by maturin
	# Seems to be needed as we are overriding clang binary name.
	# maturin does not ask for this environment variable when using NDK
	export ANDROID_API_LEVEL="$TERMUX_PKG_API_LEVEL"
	# --no-build-isolation is needed to ensure that maturin is not built for
	# cross-python and picked up for execution instead of maturin built for
	# build-python
	cross-pip install --no-build-isolation --no-deps . --prefix $TERMUX_PREFIX
}
