TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-activities"
TERMUX_PKG_DESCRIPTION="Core components for KDE's Activities"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-activities-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="39783d324f3c03404521b49264d34135756d00bcead46177a4b989f8bea7449a"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcoreaddons, kf6-kconfig, libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="boost, extra-cmake-modules, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
