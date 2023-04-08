TERMUX_PKG_HOMEPAGE=https://github.com/EFForg/apkeep
TERMUX_PKG_DESCRIPTION="A command-line tool for downloading APK files from various sources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.0"
TERMUX_PKG_SRCURL=https://github.com/EFForg/apkeep/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=439815cc2eb75df1235bb1106135548af2465e47486df6d1742cd47c0bd687dc
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
