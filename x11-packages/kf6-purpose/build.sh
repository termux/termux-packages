TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/purpose'
TERMUX_PKG_DESCRIPTION='Framework for providing abstractions to get the developers purposes fulfilled'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.31.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/purpose-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=665b579a6b4c4d6f9f19a83fe802da70a65d38d9b23193471b5b64e65b7a55c3
TERMUX_PKG_DEPENDS="kf6-kcmutils (>= ${TERMUX_PKG_VERSION%.*}), kf6-kconfig (>= ${TERMUX_PKG_VERSION%.*}), kf6-kcoreaddons (>= ${TERMUX_PKG_VERSION%.*}), kf6-ki18n (>= ${TERMUX_PKG_VERSION%.*}), kf6-kio (>= ${TERMUX_PKG_VERSION%.*}), kf6-knotifications (>= ${TERMUX_PKG_VERSION%.*}), kf6-kservice (>= ${TERMUX_PKG_VERSION%.*}), kf6-kitemmodels (>= ${TERMUX_PKG_VERSION%.*}), kf6-prison (>= ${TERMUX_PKG_VERSION%.*}), libc++, qt6-qtbase, qt6-qtdeclarative"
# kaccounts-integration, libaccounts-qt, accounts-qml-module can be added to TERMUX_PKG_DEPENDS when available
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), kf6-kirigami (>= ${TERMUX_PKG_VERSION%.*}), intltool"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
