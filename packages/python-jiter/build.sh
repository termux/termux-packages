TERMUX_PKG_HOMEPAGE=https://github.com/pydantic/jiter
TERMUX_PKG_DESCRIPTION="Fast iterable JSON parser"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="adybag14-cyber <252811164+adybag14-cyber@users.noreply.github.com>"
TERMUX_PKG_VERSION="0.13.0"
TERMUX_PKG_SRCURL="https://pypi.io/packages/source/j/jiter/jiter-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f2839f9c2c7e2dffc1bc5929a510e14ce0a946be9365fd1219e7ef342dae14f4
# Hermes Agent currently consumes this exact release from its lockfile.
# Update it in lockstep with the dependent package.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="maturin"
TERMUX_PKG_PYTHON_RUNTIME_DEPS=false
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_rust
	export CARGO_BUILD_TARGET="${CARGO_TARGET_NAME}"
	export PYO3_CROSS_LIB_DIR="${TERMUX_PREFIX}/lib"
	export ANDROID_API_LEVEL="${TERMUX_PKG_API_LEVEL}"
	export CFLAGS_${CARGO_TARGET_NAME//-/_}+=" -I$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	# Keep maturin in the build interpreter; installing it into cross-python
	# makes pip try to execute a target Android binary on the build host.
	export ANDROID_API_LEVEL="$TERMUX_PKG_API_LEVEL"
	cross-pip install --no-build-isolation --no-deps . --prefix "$TERMUX_PREFIX"
}

termux_step_post_make_install() {
	# PyO3 extension modules need an explicit libpython dependency on Android.
	local so
	so="$(find "$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/site-packages" \
		-name 'jiter*.so' -print -quit)"
	[[ -n "$so" ]] || termux_error_exit "jiter extension missing"
	local libpython="libpython${TERMUX_PYTHON_VERSION}.so"
	if ! patchelf --print-needed "$so" | grep -Fxq "$libpython"; then
		patchelf --add-needed "$libpython" "$so"
	fi
}
