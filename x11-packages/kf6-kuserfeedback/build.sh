TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kuserfeedback"
TERMUX_PKG_DESCRIPTION="Framework for collecting user feedback for applications via telemetry and surveys"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.17.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kuserfeedback-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="0f1b5361ffa6fff12ec3dfd7a3e4b1b2aa6ebadc4afcc03a9d31c2d49bec7caf"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, clang, qt6-qtcharts, qt6-qtdeclarative, qt6-qtsvg, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
