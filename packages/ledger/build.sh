TERMUX_PKG_HOMEPAGE=https://www.ledger-cli.org
TERMUX_PKG_DESCRIPTION="Powerful, double-entry accounting system"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=3.1.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/ledger/ledger/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b248c91d65c7a101b9d6226025f2b4bf3dabe94c0c49ab6d51ce84a22a39622b
TERMUX_PKG_DEPENDS="boost, libc++, libedit, libmpfr, libgmp"
TERMUX_PKG_BUILD_DEPENDS="utf8cpp"
# See https://gitlab.kitware.com/cmake/cmake/issues/18865:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBoost_NO_BOOST_CMAKE=ON"
