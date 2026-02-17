TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma5support"
TERMUX_PKG_DESCRIPTION="Porting aid to migrate from KDE Platform 5 to KDE Frameworks 6"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma5support-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=e6e7157950c12ab33099567cf28b9d9569d2e2655715ba123864d18f6071262b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kholidays, kf6-ki18n, kf6-kio, kf6-kjobwidgets, kf6-kguiaddons, kf6-kservice, kf6-knotifications, kf6-kidletime, kf6-solid, kf6-kunitconversion, libc++, libxfixes, libx11, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, plasma-activities, qt6-qttools"
TERMUX_PKG_CONFLICTS="plasma-workspace (<< 6.6.0)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
