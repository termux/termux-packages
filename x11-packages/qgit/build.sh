TERMUX_PKG_HOMEPAGE=https://github.com/tibirna/qgit
TERMUX_PKG_DESCRIPTION="A git GUI viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
# Version update requires also bumping the qt5-base package in order to get tools
# working on host (x86_64).
TERMUX_PKG_VERSION=2.9
TERMUX_PKG_REVISION=17
TERMUX_PKG_SRCURL=https://github.com/tibirna/qgit/archive/qgit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=69788efda7d434d1bc094bb414bd92c269dc7894326320634500b05d63c008e8
TERMUX_PKG_DEPENDS="git, hicolor-icon-theme, qt5-base"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_cmake

	cmake . \
		-DCMAKE_INSTALL_PREFIX="${TERMUX_PREFIX}" \
		-DQt5_DIR="${TERMUX_PREFIX}/lib/cmake/Qt5" \
		-DQt5Core_DIR="${TERMUX_PREFIX}/lib/cmake/Qt5Core"
}
