TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kstatusnotifieritem"
TERMUX_PKG_DESCRIPTION="Implementation of Status Notifier Items"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.20.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kstatusnotifieritem-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=db0edb928b15708487ea8ad007db4bcf3949332698cc78b4ed75128bea1b2fa6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, kf6-kwindowsystem"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_PYTHON_BINDINGS=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
