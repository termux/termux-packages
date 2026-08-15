TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kstatusnotifieritem"
TERMUX_PKG_DESCRIPTION="Implementation of Status Notifier Items"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.29.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kstatusnotifieritem-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b2c9375edc219425b2ffc90b443e686fc48699a0ee0408b6a4e55a5f345dde2e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, kf6-kwindowsystem"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_PYTHON_BINDINGS=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
