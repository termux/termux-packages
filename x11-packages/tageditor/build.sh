TERMUX_PKG_HOMEPAGE=https://github.com/Martchus/tageditor
TERMUX_PKG_DESCRIPTION="A tag editor with Qt GUI and command-line interface. Supports MP4 (iTunes), ID3, Vorbis, Opus, FLAC and Matroska"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Martchus/tageditor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bea420716db8f2925fe51a7a0d5979dd9283c0fa7532bcebde0a574e2cf973ae
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libc++utilities, qt6-qtbase, qt6-qtdeclarative, qtutilities, tagparser"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qtdeclarative-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWEBVIEW_PROVIDER=none
-DQT_PACKAGE_PREFIX=Qt6
-DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools
"
