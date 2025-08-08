TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma5support"
TERMUX_PKG_DESCRIPTION="Porting aid to migrate from KDE Platform 5 to KDE Frameworks 6"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.4"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma5support-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="066c0456149bacad6dfd99eb36783fb61f1918df91b9d70ff4aeac56e3d43bf5"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kjobwidgets, kf6-kguiaddons, kf6-kservice, kf6-knotifications, kf6-kidletime, kf6-solid, libx11, libxfixes"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools, plasma-activities"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
