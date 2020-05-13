TERMUX_PKG_HOMEPAGE=https://www.ledger-cli.org
TERMUX_PKG_DESCRIPTION="Powerful, double-entry accounting system"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ledger/ledger/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9a2f1886be0181bfa0a8b3ea05207d5c6e55497d7f821af3d7e60a8e53ba11d0
TERMUX_PKG_DEPENDS="boost, libc++, libedit, libmpfr, libgmp"
TERMUX_PKG_BREAKS="ledger-dev"
TERMUX_PKG_REPLACES="ledger-dev"
TERMUX_PKG_BUILD_DEPENDS="utf8cpp"
# See https://gitlab.kitware.com/cmake/cmake/issues/18865:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBoost_NO_BOOST_CMAKE=ON"
