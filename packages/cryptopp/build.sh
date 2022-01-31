TERMUX_PKG_HOMEPAGE=https://www.cryptopp.com/
TERMUX_PKG_DESCRIPTION="A free C++ class library of cryptographic schemes"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.6.0
TERMUX_PKG_SRCURL=https://github.com/weidai11/cryptopp/archive/refs/tags/CRYPTOPP_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=9304625f4767a13e0a5f26d0f019d78cf9375604a33e5391c3bf2e81399dfeb8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+.\d+.\d+"
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
