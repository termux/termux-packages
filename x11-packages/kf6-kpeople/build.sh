TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kpeople"
TERMUX_PKG_DESCRIPTION="A library that provides access to all contacts and the people who hold them"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.24.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kpeople-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d3e267753eb64c3bbba8e4af4a4503695ee62d015b30c2dad1a1f1343890fea4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcontacts, kf6-kcoreaddons, kf6-ki18n, kf6-kitemviews, kf6-kwidgetsaddons, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
