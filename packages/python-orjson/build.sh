TERMUX_PKG_HOMEPAGE=https://github.com/ijl/orjson
TERMUX_PKG_DESCRIPTION="Fast, correct Python JSON library supporting dataclasses, datetimes and numpy"
TERMUX_PKG_LICENSE="Apache-2.0, MIT, MPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT, LICENSE-MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.12.0"
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/o/orjson/orjson-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d14203fb1aae2ad9b3d52f8a0e82aeb10197ef1c9bc61da7f358bd70b00123d5
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="maturin"

termux_step_configure() {
	termux_setup_rust
	export CARGO_BUILD_TARGET="${CARGO_TARGET_NAME}"
	export PYO3_CROSS_LIB_DIR="${TERMUX_PREFIX}/lib"
	# Pin the interpreter explicitly. pyo3 otherwise scans PYO3_CROSS_LIB_DIR and
	# picks up whichever libpython it finds there, which can produce an extension
	# built for one version but installed under another.
	export PYO3_CROSS_PYTHON_VERSION="${TERMUX_PYTHON_VERSION}"
	export ANDROID_API_LEVEL="${TERMUX_PKG_API_LEVEL}"
	export CFLAGS_${CARGO_TARGET_NAME//-/_}+=" -I$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION"
}

termux_step_make_install() {
	# Needed by maturin, which does not derive it from the NDK when the clang
	# binary name is overridden.
	export ANDROID_API_LEVEL="$TERMUX_PKG_API_LEVEL"
	# pip leaves earlier builds in place, so an extension module from a previous
	# run would otherwise be packaged alongside the current one.
	rm -rf "${TERMUX_PREFIX}/lib/python${TERMUX_PYTHON_VERSION}/site-packages/orjson"
	# --no-build-isolation keeps maturin from being rebuilt for the cross python
	# and then executed, instead of the one built for the build python.
	cross-pip install --no-build-isolation --no-deps . --prefix "$TERMUX_PREFIX"
}

termux_step_post_make_install() {
	# The Android linker, unlike the one on Linux, requires the extension to be
	# linked against libpython. maturin does not always arrange that, so add the
	# dependency when it is missing. Compare the python-cryptography package,
	# which does this unconditionally.
	local _so
	_so="$(find "${TERMUX_PREFIX}/lib/python${TERMUX_PYTHON_VERSION}/site-packages/orjson" \
		-name 'orjson*.so' -print -quit)"
	if [ -z "${_so}" ]; then
		termux_error_exit "Could not locate the orjson extension module"
	fi
	if ! patchelf --print-needed "${_so}" | grep -qx "libpython${TERMUX_PYTHON_VERSION}.so"; then
		patchelf --add-needed "libpython${TERMUX_PYTHON_VERSION}.so" "${_so}"
	fi
}
