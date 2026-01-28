TERMUX_PKG_HOMEPAGE=https://aosc.io/oma
TERMUX_PKG_DESCRIPTION="oma is an attempt at reworking APT's interface"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.23.4"
TERMUX_PKG_SRCURL="https://github.com/AOSC-Dev/oma/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f317bf51620f743210ade6383d4276d33fe580b18c0995aae11061f733a4577c
TERMUX_PKG_DEPENDS="libnettle, apt"
TERMUX_PKG_RECOMMENDS="ripgrep"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="v\d+\.\d+\.\d+(?!-)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--no-default-features
--features nice-setup
"

termux_step_pre_configure() {
	termux_setup_rust

	# error: function-like macro '__GLIBC_USE' is not defined
	export BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME//-/_}="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot --target=${CARGO_TARGET_NAME}"
	CXXFLAGS+=" $CPPFLAGS"
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/oma
}
