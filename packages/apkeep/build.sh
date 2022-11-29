TERMUX_PKG_HOMEPAGE=https://github.com/EFForg/apkeep
TERMUX_PKG_DESCRIPTION="A command-line tool for downloading APK files from various sources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.1"
TERMUX_PKG_SRCURL=https://github.com/EFForg/apkeep/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4992ac302d3779ba4d10980034b9cf25a1c61cebd51c789d32ec3836cc947964
TERMUX_PKG_DEPENDS="openssl (>= 3.0.3)"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include/openssl
	export OPENSSL_LIB_DIR=$TERMUX_PREFIX/lib
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/apkeep
}
