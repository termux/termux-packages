TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="KDE Access to window manager"
TERMUX_PKG_LICENSE="LGPL-2.1, LGPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="\
LICENSES/CC0-1.0.txt
LICENSES/LGPL-2.1-only.txt
LICENSES/LGPL-2.1-or-later.txt
LICENSES/LGPL-3.0-only.txt
LICENSES/LicenseRef-KDE-Accepted-LGPL.txt
LICENSES/MIT.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.9.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kwindowsystem-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9b0f96fb0073f7ba89788cd5a10fba6f960cea86eba2b03336fa6e309e5e875b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libwayland, libx11, libxcb, libxfixes, qt6-qtbase, qt6-qtdeclarative, qt6-qtwayland, xcb-util-keysyms"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), libwayland-protocols, plasma-wayland-protocols, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
