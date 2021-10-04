TERMUX_PKG_HOMEPAGE=https://github.com/rockdaboot/libpsl
TERMUX_PKG_DESCRIPTION="Public Suffix List library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.21.1
TERMUX_PKG_SRCURL=https://github.com/rockdaboot/libpsl/releases/download/${TERMUX_PKG_VERSION}/libpsl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ac6ce1e1fbd4d0254c4ddb9d37f1fa99dec83619c1253328155206b896210d4c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libidn2, libunistring"
TERMUX_PKG_BREAKS="libpsl-dev"
TERMUX_PKG_REPLACES="libpsl-dev"

termux_step_pre_configure() {
	autoreconf -fiv
}
