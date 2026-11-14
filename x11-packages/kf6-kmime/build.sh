TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kmime"
TERMUX_PKG_DESCRIPTION="Library for handling mail messages and newsgroup articles"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.32.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kmime-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=390870842f4b6afeab01a0f76b63e22f0b97f788f8815d847a43d7a4f23e7941
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs (>= ${TERMUX_PKG_VERSION%.*}), libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_BREAKS="kmime"
TERMUX_PKG_REPLACES="kmime"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
