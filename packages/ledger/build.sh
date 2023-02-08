TERMUX_PKG_HOMEPAGE=https://www.ledger-cli.org
TERMUX_PKG_DESCRIPTION="Powerful, double-entry accounting system"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.0
TERMUX_PKG_SRCURL=https://github.com/ledger/ledger/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=42307121666b5195a122857ec572e554b77ecf6b12c53e716756c9dae20dc7c1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libc++, libedit, libmpfr, libgmp, python"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, utf8cpp"
TERMUX_PKG_BREAKS="ledger-dev"
TERMUX_PKG_REPLACES="ledger-dev"
# See https://gitlab.kitware.com/cmake/cmake/issues/18865:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBoost_NO_BOOST_CMAKE=ON
-DUSE_PYTHON=ON
-DUTFCPP_PATH=$TERMUX_PREFIX/include/utf8cpp
"

termux_step_pre_configure() {
	sed $TERMUX_PKG_BUILDER_DIR/CMakeLists.diff \
		-e "s%@TERMUX_PREFIX@%${TERMUX_PREFIX}%g" \
		-e "s%@PYTHON_VERSION@%${TERMUX_PYTHON_VERSION}%g" \
		| patch --silent -p1
}
