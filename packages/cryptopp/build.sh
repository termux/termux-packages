TERMUX_PKG_HOMEPAGE=https://www.cryptopp.com/
TERMUX_PKG_DESCRIPTION="A free C++ class library of cryptographic schemes"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=8.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/weidai11/cryptopp/archive/refs/tags/CRYPTOPP_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=8f64cf09cf4f61d5d74bca53574b8cc9959186cc0f072a2e6597e4999d6ad5db
TERMUX_PKG_BREAKS="cryptopp-dev"
TERMUX_PKG_REPLACES="cryptopp-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAKE_INSTALL_TARGET="install-lib"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/
share/cryptopp/
"

termux_step_pre_configure() {
	export CXXFLAGS+=" -fPIC -DCRYPTOPP_DISABLE_ASM"
	export TERMUX_PKG_EXTRA_MAKE_ARGS+=" dynamic libcryptopp.pc CC=$CC CXX=$CXX"
}
