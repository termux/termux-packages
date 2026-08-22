TERMUX_PKG_HOMEPAGE=https://github.com/pydantic/pydantic-core
TERMUX_PKG_DESCRIPTION="Core validation logic for Pydantic written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="adybag14-cyber <252811164+adybag14-cyber@users.noreply.github.com>"
TERMUX_PKG_VERSION="2.46.4"
TERMUX_PKG_SRCURL="https://pypi.io/packages/source/p/pydantic-core/pydantic_core-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1
# Pydantic pins pydantic-core exactly. Keep this release coordinated with
# packages that consume it instead of independently auto-bumping the ABI.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="maturin"
# Keep the framework-generated Python dependency check pinned to the APT-owned
# native package.  The upstream METADATA name uses an underscore, so without
# this exact self-pin the generic debscript can treat it as upgradeable and
# replace it with a newer PyPI sdist during pkg install.
TERMUX_PKG_PYTHON_RUNTIME_DEPS="'pydantic-core==${TERMUX_PKG_VERSION}'"
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
		-name '_pydantic_core*.so' -print -quit)"
	[[ -n "$so" ]] || termux_error_exit "pydantic-core extension missing"
	local libpython="libpython${TERMUX_PYTHON_VERSION}.so"
	if ! patchelf --print-needed "$so" | grep -Fxq "$libpython"; then
		patchelf --add-needed "$libpython" "$so"
	fi
}
