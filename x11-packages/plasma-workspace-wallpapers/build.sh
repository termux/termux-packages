TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-workspace-wallpapers"
TERMUX_PKG_DESCRIPTION="Additional wallpapers for the Plasma Workspace"
TERMUX_PKG_LICENSE="LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-workspace-wallpapers-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="025910fbb7694629714f17e07dce27880d9da33a8f3d01c0baae663e94156a5b"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_WITH_QT6=ON
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
