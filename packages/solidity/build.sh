TERMUX_PKG_HOMEPAGE=https://solidity.readthedocs.io
TERMUX_PKG_DESCRIPTION="An Ethereum smart contract-oriented language"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.23"
TERMUX_PKG_SRCURL=https://github.com/ethereum/solidity/releases/download/v${TERMUX_PKG_VERSION}/solidity_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cce2c489ba0e29a5c37cc58bd3b3621d996658ffc78c6be8e75f744698068239
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
