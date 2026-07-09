TERMUX_PKG_HOMEPAGE=https://github.com/pyca/cryptography
TERMUX_PKG_DESCRIPTION="Provides cryptographic recipes and primitives to Python developers"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.APACHE, LICENSE.BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.0.0"
TERMUX_PKG_SRCURL="https://github.com/pyca/cryptography/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a533606510cdea9e0f0616c61b18dbe3cfa5a2bbfbf48344a159d6ddc207ae13
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
	export CFLAGS_${CARGO_TARGET_NAME//-/_}+=" -I$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION"
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

termux_step_post_make_install() {
	# maturin doesn't honor python-config, so it doesn't link the built module against libpython
	# Due to differences in between the Android linker and on Linux, linking against libpython is needed
	# Looking at https://github.com/PyO3/pyo3/issues/1082, it seems like maturin does try to link against libpython
	# but looking at the source, it seems to do only for binary targets, not library.
	# Anyways, do it ourselves not worth the effort to ask upstream for a single package we have
	patchelf \
		--add-needed libpython${TERMUX_PYTHON_VERSION}.so \
		"${TERMUX_PREFIX}/lib/python${TERMUX_PYTHON_VERSION}/site-packages/cryptography/hazmat/bindings/_rust.abi3.so"
}
