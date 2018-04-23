TERMUX_PKG_HOMEPAGE=https://lz4.github.io/lz4/
TERMUX_PKG_DESCRIPTION="Fast LZ compression algorithm library"
TERMUX_PKG_VERSION=1.8.1.2
TERMUX_PKG_SHA256=12f3a9e776a923275b2dc78ae138b4967ad6280863b77ff733028ce89b8123f9
TERMUX_PKG_SRCURL=https://github.com/lz4/lz4/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+=lib
}
