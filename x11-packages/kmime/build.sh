TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kmime"
TERMUX_PKG_DESCRIPTION="Library for handling mail messages and newsgroup articles"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmime-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a118b0d3b3ad2ebb35f73c675cffff575cd1b36ff5875d4f9fd4bce884bbae8a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
