TERMUX_PKG_HOMEPAGE=https://www.texstudio.org/
TERMUX_PKG_DESCRIPTION="A fully featured LaTeX editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.7.2"
TERMUX_PKG_SRCURL=https://github.com/texstudio-org/texstudio/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c40bcdd50bb97d0174a6f67c6e2e3e135b265579185490c6757c30689ff7353d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="hunspell, libc++, libx11, poppler-qt, qt5-qtbase, qt5-qtdeclarative, qt5-qtsvg, qt5-qttools, quazip, texstudio-data, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_RECOMMENDS="ghostscript"
TERMUX_PKG_SUGGESTS="texlive-installer"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PKG_CONFIG=pkg-config
PREFIX=$TERMUX_PREFIX
USE_SYSTEM_HUNSPELL=1
USE_SYSTEM_QUAZIP=1
"

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
