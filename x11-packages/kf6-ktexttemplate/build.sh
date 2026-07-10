TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/ktexttemplate"
TERMUX_PKG_DESCRIPTION="Library to allow application developers to separate the structure of documents from the data they contain"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.28.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/ktexttemplate-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a184163f7d5d2ac4cd4a71d04bee830020332552bfa9eb5159ced57b20edd527
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
