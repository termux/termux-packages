TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Secure and unified container for user passwords'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.13.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kwallet-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1a6ff2ccf660a433bda6b00ac873796dcb46bd2443787fcf5fbe4c433ca8cb36
TERMUX_PKG_DEPENDS="gpgme, gpgmepp, kf6-kcolorscheme (>= ${TERMUX_PKG_VERSION}), kf6-kconfig (>= ${TERMUX_PKG_VERSION}), kf6-kcoreaddons (>= ${TERMUX_PKG_VERSION}), kf6-kcrash (>= ${TERMUX_PKG_VERSION}), kf6-kdbusaddons (>= ${TERMUX_PKG_VERSION}), kf6-ki18n (>= ${TERMUX_PKG_VERSION}), kf6-knotifications (>= ${TERMUX_PKG_VERSION}), kf6-kwidgetsaddons (>= ${TERMUX_PKG_VERSION}), kf6-kwindowsystem (>= ${TERMUX_PKG_VERSION}), libc++, libgcrypt, qca, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), kf6-kservice (>= ${TERMUX_PKG_VERSION}), qt6-qttools"
# TERMUX_PKG_RECOMMENDS="kwalletmanager"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
