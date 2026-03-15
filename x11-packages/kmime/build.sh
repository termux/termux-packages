TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kmime"
TERMUX_PKG_DESCRIPTION="Library for handling mail messages and newsgroup articles"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmime-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="fce3c603cac3fec9a3f0e101c49785c32ace07b8f60b52739b638d329f43826d"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
