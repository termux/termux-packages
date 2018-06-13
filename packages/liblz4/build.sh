TERMUX_PKG_HOMEPAGE=https://lz4.github.io/lz4/
TERMUX_PKG_DESCRIPTION="Fast LZ compression algorithm library"
TERMUX_PKG_VERSION=1.8.2
TERMUX_PKG_SHA256=0963fbe9ee90acd1d15e9f09e826eaaf8ea0312e854803caf2db0a6dd40f4464
TERMUX_PKG_SRCURL=https://github.com/lz4/lz4/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+=lib
}
