TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/phonon"
TERMUX_PKG_DESCRIPTION="The multimedia framework by KDE"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.12.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/phonon/${TERMUX_PKG_VERSION}/phonon-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="3287ffe0fbcc2d4aa1363f9e15747302d0b080090fe76e5f211d809ecb43f39a"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, pulseaudio, pulseaudio-glib, qt6-qt5compat, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_RECOMMENDS="phonon-qt6-vlc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DPHONON_BUILD_QT5=OFF
"
