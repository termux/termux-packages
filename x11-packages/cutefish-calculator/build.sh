TERMUX_PKG_HOMEPAGE=https://github.com/cutefishos/calculator
TERMUX_PKG_DESCRIPTION="CutefishOS Calculator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4
TERMUX_PKG_SRCURL=https://github.com/cutefishos/calculator/archive/${TERMUX_PKG_VERSION}/cutefish-calculator-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c50f80545c4d96f1632541da53cd030e353237177f3de8b014a5d3d469102da
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools, qt5-qtquickcontrols2, qt5-qttools-cross-tools"
TERMUX_CMAKE_BUILD="Unix Makefiles"
TERMUX_PKG_EXTRA_MAKE_ARGS="VERBOSE=1"

termux_step_post_massage() {
	return 1
}
