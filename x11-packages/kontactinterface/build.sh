TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kontactinterface"
TERMUX_PKG_DESCRIPTION="Kontact Plugin Interface Library"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kontactinterface-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="ff55c854955e93418ef2afb72b060e928e71b5d3c5f92b8e0e75ee8a59ff57b7"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcoreaddons, kf6-kio, kf6-kparts, kf6-kwindowsystem, kf6-kxmlgui, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
