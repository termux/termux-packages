TERMUX_PKG_HOMEPAGE="https://www.kdbg.org/"
TERMUX_PKG_DESCRIPTION="Kdbg is a Qt-based interface for gdb, the GNU debugger."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="3.2.0"
TERMUX_PKG_SRCURL="https://github.com/j6t/kdbg/archive/refs/tags/kdbg-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5c9fd8e60d99ac76995b633f2f6a2950380f1829201596aaac1b1b520ab218e2
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdb, kf6-kconfig, kf6-ki18n, kf6-kcoreaddons, kf6-kiconthemes, kf6-kxmlgui, kf6-kwindowsystem, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kconfig-cross-tools, qt6-qttools, qt6-qt5compat, qt6-qt5compat-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_FOR_KDE_VERSION=6
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
