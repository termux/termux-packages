TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/threadweaver"
TERMUX_PKG_DESCRIPTION="High-level multithreading framework"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/threadweaver-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d4826e0d8faf135655d15969b27d0fe6fc746a6d308ea34f04bed3de60518b0b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
