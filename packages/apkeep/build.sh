TERMUX_PKG_HOMEPAGE=https://github.com/EFForg/apkeep
TERMUX_PKG_DESCRIPTION="A command-line tool for downloading APK files from various sources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/EFForg/apkeep/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f5fa0d8c02d5c078f69ec18e080463113c3794be8b94130f6a81f463c36bca0b
TERMUX_PKG_DEPENDS="openssl (>= 3.0.3)"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include
	export OPENSSL_LIB_DIR=$TERMUX_PREFIX/lib
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/apkeep
}
