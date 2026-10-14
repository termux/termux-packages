TERMUX_PKG_HOMEPAGE=https://github.com/pydantic/pydantic-core
TERMUX_PKG_DESCRIPTION="Core validation logic for pydantic, written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Eutalix"
TERMUX_PKG_VERSION="2.50.0"
# pydantic-core no longer has its own tags/releases: it lives inside the
# pydantic/pydantic monorepo, whose tags follow the versioning of the
# `pydantic` package (pure Python), not `pydantic-core`. We therefore pin
# to an exact commit SHA, resolved by walking the commit history of
# `pydantic-core/Cargo.toml` until its `version` field matches a stable
# release published on PyPI (the ones that ship actual wheels).
#
# To find the next commit when bumping this package:
#   1. Check https://pypi.org/pypi/pydantic-core/json for the newest
#      stable version with published wheels.
#   2. Walk https://github.com/pydantic/pydantic/commits/main/pydantic-core/Cargo.toml
#      backwards until `version = "X.Y.Z"` matches that PyPI version.
#   3. Use that commit's SHA below and update TERMUX_PKG_VERSION/SHA256.
_PYDANTIC_CORE_COMMIT="a656b75d58a80f5033f376f7af17092606bbfde2"
TERMUX_PKG_SRCURL="https://github.com/pydantic/pydantic/archive/${_PYDANTIC_CORE_COMMIT}.tar.gz"
TERMUX_PKG_SHA256=f4033e27516875da8d5a4999f778539d354c866864f6db6fc9f168faf668f620
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_BUILD_IN_SRC=true
# No reliable automatic update method exists: see the note above about
# tags in the monorepo not corresponding to pydantic-core releases.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="maturin"

# The crate we actually want to build lives in a subdirectory of the
# monorepo tarball.
_PKG_SRCDIR_SUBDIR="pydantic-core"

termux_step_configure() {
	termux_setup_rust
	export CARGO_BUILD_TARGET="${CARGO_TARGET_NAME}"
	export PYO3_CROSS_LIB_DIR="${TERMUX_PREFIX}/lib"
	export ANDROID_API_LEVEL="${TERMUX_PKG_API_LEVEL}"
	export CFLAGS_${CARGO_TARGET_NAME//-/_}+=" -I$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION"
}

termux_step_make() {
	# The actual build happens in termux_step_make_install via
	# maturin/cross-pip. We override this step as a no-op because the
	# default implementation would otherwise run `make` at the root of
	# TERMUX_PKG_SRCDIR, which is the pydantic/pydantic monorepo root -
	# its Makefile belongs to the `pydantic` package (pure Python) and
	# is unrelated to building pydantic-core.
	:
}

termux_step_make_install() {
	export ANDROID_API_LEVEL="$TERMUX_PKG_API_LEVEL"
	cd "$TERMUX_PKG_SRCDIR/$_PKG_SRCDIR_SUBDIR"
	# --no-build-isolation avoids cross-python's maturin being confused
	# with build-python's maturin.
	cross-pip install --no-build-isolation --no-deps . --prefix "$TERMUX_PREFIX"
}
