TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=98
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/WebAssembly/binaryen/archive/version_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f805db6735869ab52cde7c0404879c90cf386888c0f587e944737550171c1c4

termux_step_post_make_install () {
      export EM_BINARYEN_ROOT=$TERMUX_PREFIX/usr/bin
}
