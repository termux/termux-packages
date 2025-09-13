TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kstatusnotifieritem"
TERMUX_PKG_DESCRIPTION="Implementation of Status Notifier Items"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.18.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kstatusnotifieritem-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d78aa20e1858f700478eecedb49714160d5e04b4a0d177bca4355aa1a0f7d730
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, kf6-kwindowsystem"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_PYTHON_BINDINGS=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
