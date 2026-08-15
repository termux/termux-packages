TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kcontacts"
TERMUX_PKG_DESCRIPTION="Address book API for KDE"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.29.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kcontacts-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=08f8bfe83c5d4516b5c76877ac51aba8e7001242cd56d1e2a987bc8410af53fd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
