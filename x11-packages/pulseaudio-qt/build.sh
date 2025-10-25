TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/pulseaudio-qt"
TERMUX_PKG_DESCRIPTION="Qt bindings for libpulse"
TERMUX_PKG_LICENSE="LGPL-2.1-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/pulseaudio-qt/pulseaudio-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="6a18db76dd2bcc3df7d9a9379c025295817264baa1f2ed8caaac7da44e04e931"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, pulseaudio, pulseaudio-glib, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
