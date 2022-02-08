TERMUX_PKG_HOMEPAGE=https://www.ledger-cli.org
TERMUX_PKG_DESCRIPTION="Powerful, double-entry accounting system"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.1
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://github.com/ledger/ledger/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=92bf09bc385b171987f456fe3ee9fa998ed5e40b97b3acdd562b663aa364384a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libc++, libedit, libmpfr, libgmp, python"
TERMUX_PKG_BREAKS="ledger-dev"
TERMUX_PKG_REPLACES="ledger-dev"
TERMUX_PKG_BUILD_DEPENDS="utf8cpp"
# See https://gitlab.kitware.com/cmake/cmake/issues/18865:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBoost_NO_BOOST_CMAKE=ON
-DUSE_PYTHON=ON
-DUTFCPP_PATH=$TERMUX_PREFIX/include/utf8cpp
"
