TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kactivitymanagerd"
TERMUX_PKG_DESCRIPTION="System service to manage user activities and track the usage patterns"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kactivitymanagerd-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="87a0f8865f180fc69dcab2fe75d9a840fb39c99393c1d37c11a3d3a30171fbf8"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kglobalaccel, kf6-ki18n, kf6-kio, kf6-kservice, kf6-kxmlgui, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
