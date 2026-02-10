TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/libkdepim"
TERMUX_PKG_DESCRIPTION="Libraries for KDE PIM applications"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/libkdepim-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="089f1b24839a66b234e987f9eb71aca9efe20c2e9d8dd7387f24c14cbff37bf5"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-ki18n, kf6-kwidgetsaddons, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kcompletion, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
