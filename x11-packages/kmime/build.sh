TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kmime"
TERMUX_PKG_DESCRIPTION="Library for handling mail messages and newsgroup articles"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmime-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="ce8d5c95f8beaa1dc11201d1ee903689955455247c76cdaf8ef17400bffd4ad1"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
