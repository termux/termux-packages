TERMUX_PKG_HOMEPAGE=https://solidity.readthedocs.io
TERMUX_PKG_DESCRIPTION="An Ethereum smart contract-oriented language"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.19"
TERMUX_PKG_SRCURL=https://github.com/ethereum/solidity/releases/download/v${TERMUX_PKG_VERSION}/solidity_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9bc195e1695f271b65326c73a12223377d52ae4b4fee10589c5e7bde6fa44194
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, jsoncpp, libc++"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_Z3=OFF
-DUSE_CVC4=OFF
-DUSE_LD_GOLD=OFF
-DBoost_USE_STATIC_LIBS=OFF
"
TERMUX_CMAKE_BUILD="Unix Makefiles"

termux_step_pre_configure() {
	LDFLAGS+=" -ljsoncpp"
}
