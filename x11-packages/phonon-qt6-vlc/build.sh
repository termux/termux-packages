TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/phonon-vlc"
TERMUX_PKG_DESCRIPTION="Phonon VLC backend"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/phonon/phonon-backend-vlc/${TERMUX_PKG_VERSION}/phonon-backend-vlc-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="338479dc451e4b94b3ca5b578def741dcf82f5c626a2807d36235be2dce7c9a5"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, phonon-qt6, pulseaudio, qt6-qtbase, vlc-qt"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DPHONON_BUILD_QT5=OFF
-DPHONON_BUILD_QT6=ON
"
