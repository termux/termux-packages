TERMUX_PKG_HOMEPAGE=https://wasmer.io
TERMUX_PKG_DESCRIPTION="The leading WebAssembly Runtime library supporting WASI and Emscripten"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_SRCURL=https://github.com/wasmerio/wasmer/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f0d86dcd98882a7459f10e58671acf233b7d00f50dffe32f5770ab3bf850a9a6
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	export WASMER_INSTALL_PREFIX=$TERMUX_PREFIX
	make build-wasmer
}

termux_step_make_install() {
    make install DESTDIR=$WASMER_INSTALL_PREFIX
}
