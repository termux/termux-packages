TERMUX_PKG_HOMEPAGE=https://www.ledger-cli.org
TERMUX_PKG_DESCRIPTION="Powerful, double-entry accounting system"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/ledger/ledger/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1cf012cdc8445cab0efc445064ef9b2d3f46ed0165dae803c40fe3d2b23fdaad
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libc++, libedit, libmpfr, libgmp, python"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, utf8cpp"
TERMUX_PKG_BREAKS="ledger-dev"
TERMUX_PKG_REPLACES="ledger-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_PYTHON=ON
-DUTFCPP_PATH=$TERMUX_PREFIX/include/utf8cpp
"

termux_step_pre_configure() {
	sed $TERMUX_PKG_BUILDER_DIR/CMakeLists.diff \
		-e "s%@TERMUX_PREFIX@%${TERMUX_PREFIX}%g" \
		-e "s%@PYTHON_VERSION@%${TERMUX_PYTHON_VERSION}%g" \
		| patch --silent -p1
}
