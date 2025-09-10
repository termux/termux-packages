TERMUX_PKG_HOMEPAGE=https://github.com/pyca/bcrypt
TERMUX_PKG_DESCRIPTION="Acceptable password hashing for your software and your servers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://pypi.io/packages/source/b/bcrypt/bcrypt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_DEPENDS="openssl"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, setuptools-rust"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_configure() {
	export CARGO_BUILD_TARGET=${CARGO_TARGET_NAME}
	export PYO3_CROSS_LIB_DIR=$TERMUX_PREFIX/lib
}
