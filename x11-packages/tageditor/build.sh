TERMUX_PKG_HOMEPAGE=https://github.com/Martchus/tageditor
TERMUX_PKG_DESCRIPTION="A tag editor with Qt GUI and command-line interface. Supports MP4 (iTunes), ID3, Vorbis, Opus, FLAC and Matroska"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Martchus/tageditor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f8d80ca7da8395d5d704ae9bfc8bb9ea5a562df131ceb99ffc5318a2670b6cf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libc++utilities, qt6-qtbase, qt6-qtdeclarative, qtutilities, tagparser"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qtdeclarative-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWEBVIEW_PROVIDER=none
-DQT_PACKAGE_PREFIX=Qt6
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
