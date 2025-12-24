TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/kpackage'
TERMUX_PKG_DESCRIPTION='Framework that lets applications manage user installable packages of non-binary assets'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.21.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kpackage-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="3c5a96b07e28ac90e51dfa3afc1790213e9e191d867f112132375c95aa043c76"
TERMUX_PKG_DEPENDS="kf6-karchive (>= ${TERMUX_PKG_VERSION%.*}), kf6-kcoreaddons (>= ${TERMUX_PKG_VERSION%.*}), kf6-ki18n (>= ${TERMUX_PKG_VERSION%.*}), libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
