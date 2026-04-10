TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kcontacts"
TERMUX_PKG_DESCRIPTION="Address book API for KDE"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.25.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kcontacts-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=386826b3886d6b32a4583e638493ccd3cfb37722faaf318742d70d6bf0e3f0a7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
