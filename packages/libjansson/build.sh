TERMUX_PKG_HOMEPAGE=http://www.digip.org/jansson/
TERMUX_PKG_DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.12
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=76260d30e9bbd0ef392798525e8cd7fe59a6450c54ca6135672e3cd6a1642941
TERMUX_PKG_BREAKS="libjansson-dev"
TERMUX_PKG_REPLACES="libjansson-dev"
TERMUX_PKG_SRCURL=https://github.com/akheron/jansson/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	autoreconf -fi
}
