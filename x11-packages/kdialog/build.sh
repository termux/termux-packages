TERMUX_PKG_HOMEPAGE="https://invent.kde.org/utilities/kdialog"
TERMUX_PKG_DESCRIPTION="A utility for displaying dialog boxes from shell scripts"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdialog-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="cd612d72c629a5eab5dd2b6385e93e0926df39a6874ece0cf989d345d3aa225f"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kwindowsystem, libc++, libx11, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
