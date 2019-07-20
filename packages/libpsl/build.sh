TERMUX_PKG_HOMEPAGE=https://github.com/rockdaboot/libpsl
TERMUX_PKG_DESCRIPTION="Public Suffix List library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.21.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/rockdaboot/libpsl/releases/download/libpsl-${TERMUX_PKG_VERSION}/libpsl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=41bd1c75a375b85c337b59783f5deb93dbb443fb0a52d257f403df7bd653ee12
TERMUX_PKG_DEPENDS="libidn2, libunistring"
TERMUX_PKG_BREAKS="libpsl-dev"
TERMUX_PKG_REPLACES="libpsl-dev"

termux_step_pre_configure() {
	autoreconf -fiv
}
