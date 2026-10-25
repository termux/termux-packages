TERMUX_PKG_HOMEPAGE="https://invent.kde.org/system/liquidshell"
TERMUX_PKG_DESCRIPTION="Basic desktop shell using QtWidgets"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/liquidshell/liquidshell-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="4e079293a90c47fc3c862f4aa9472936a4cb8a2c72f16098d234997e86c8364a"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kcmutils, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemviews, kf6-knewstuff, kf6-knotifications, kf6-kservice, kf6-kstatusnotifieritem, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-solid, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
