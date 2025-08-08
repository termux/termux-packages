TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kdeclarative"
TERMUX_PKG_DESCRIPTION="Provides integration of QML and KDE Frameworks"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.16.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kdeclarative-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="c58df7a1f501286f96d0cf0b396598ede16eb3cadbc8a05d35236ce4df31c80e"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, kf6-kconfig, kf6-ki18n, kf6-kguiaddons, kf6-kwidgetsaddons, kf6-kglobalaccel, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools, qt6-shadertools, spirv-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
