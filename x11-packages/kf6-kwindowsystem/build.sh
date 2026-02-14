TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kwindowsystem"
TERMUX_PKG_DESCRIPTION="KDE Access to window manager"
TERMUX_PKG_LICENSE="CC0-1.0, LGPL-2.1-only, LGPL-2.1-or-later, LGPL-3.0-only, LGPL-3.0-or-later, MIT"
TERMUX_PKG_LICENSE_FILE="\
LICENSES/CC0-1.0.txt
LICENSES/LGPL-2.1-only.txt
LICENSES/LGPL-2.1-or-later.txt
LICENSES/LGPL-3.0-only.txt
LICENSES/LicenseRef-KDE-Accepted-LGPL.txt
LICENSES/MIT.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kwindowsystem-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4f779405d61693d0559a68a180f4ceab40a74f92f508663d680d6b79a16dd627
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libwayland, libx11, libxcb, libxfixes, qt6-qtbase, qt6-qtdeclarative, xcb-util-keysyms"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), libwayland-protocols, plasma-wayland-protocols, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
