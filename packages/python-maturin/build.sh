TERMUX_PKG_HOMEPAGE=https://github.com/PyO3/maturin
TERMUX_PKG_DESCRIPTION="Build and publish crates with pyo3, cffi and uniffi bindings as well as rust binaries as python packages"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="license-apache, license-mit"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.1"
TERMUX_PKG_SRCURL=https://pypi.io/packages/source/m/maturin/maturin-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=147754cb3d81177ee12d9baf575d93549e76121dacd3544ad6a50ab718de2b9c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, setuptools, setuptools-rust"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_configure() {
	export CARGO_BUILD_TARGET=${CARGO_TARGET_NAME}
	export PYO3_CROSS_LIB_DIR=$TERMUX_PREFIX/lib # Seem useless if build by setuptools-rust
}
