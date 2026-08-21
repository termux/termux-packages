TERMUX_PKG_HOMEPAGE="https://git.outfoxxed.me/quickshell/quickshell"
TERMUX_PKG_DESCRIPTION="Flexible toolkit for making desktop shells with QtQuick"
TERMUX_PKG_LICENSE="LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.1"
TERMUX_PKG_SRCURL="https://github.com/quickshell-mirror/quickshell/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=218f6327293928bcb1f9b25728b336c4ab125f67fe1babd7d47313f890a16c99
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="hicolor-icon-theme, libc++, libdrm, libglvnd, libwayland, libxcb, mesa, pipewire, qt6-qtbase, qt6-qtdeclarative, qt6-qtsvg, qt6-qtwayland"
TERMUX_PKG_BUILD_DEPENDS="cli11, libwayland-protocols, qt6-shadertools, spirv-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCRASH_HANDLER=OFF
-DUSE_JEMALLOC=OFF
-DSERVICE_PAM=OFF
-DSERVICE_POLKIT=OFF
-DINSTALL_QML_PREFIX=lib/qt6/qml
"

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-c++11-narrowing"
}
