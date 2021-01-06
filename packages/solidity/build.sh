TERMUX_PKG_HOMEPAGE=https://solidity.readthedocs.io
TERMUX_PKG_DESCRIPTION="An Ethereum smart contract-oriented language."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL=https://github.com/ethereum/solidity/releases/download/v${TERMUX_PKG_VERSION}/solidity_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5a8f9f421dcf65d552b2e6fea4929aef68706a8db8b2e626e7a81e4e5ee11549
TERMUX_PKG_DEPENDS="boost-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_Z3=OFF -DUSE_CVC4=OFF"
TERMUX_CMAKE_BUILD="Unix Makefiles"
