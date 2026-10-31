TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/ktnef"
TERMUX_PKG_DESCRIPTION="API for handling TNEF data"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/ktnef-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=07950712fee0b4965405ce0498e66505adf9c850fd2a7463111c38a474866ad8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kcalutils, kf6-kcalendarcore, kf6-kcontacts, kf6-ki18n, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
