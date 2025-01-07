TERMUX_PKG_HOMEPAGE=https://github.com/juzzlin/Heimer
TERMUX_PKG_DESCRIPTION="Heimer is a simple cross-platform mind map, diagram, and note-taking tool written in Qt."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/juzzlin/Heimer/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=47fb77842b1f870bc545a7229a0d1a7f81fc69f99943adee66cb6e96a1c34940
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_WITH_QT6=ON
"
