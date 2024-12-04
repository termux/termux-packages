TERMUX_PKG_HOMEPAGE=https://github.com/Martchus/tageditor
TERMUX_PKG_DESCRIPTION="A tag editor with Qt GUI and command-line interface. Supports MP4 (iTunes), ID3, Vorbis, Opus, FLAC and Matroska"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.4"
TERMUX_PKG_SRCURL=https://github.com/Martchus/tageditor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4a417b0ea7c4c39c2b96822696a5dedcb8a9613ecd2439147fbe1b148d4248f5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libc++utilities, qt6-qtbase, qt6-qtdeclarative, qtutilities, tagparser"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qtdeclarative-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWEBVIEW_PROVIDER=none
-DQT_PACKAGE_PREFIX=Qt6
-DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools
"
