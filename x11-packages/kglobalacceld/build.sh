TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kglobalacceld"
TERMUX_PKG_DESCRIPTION="Daemon providing Global Keyboard Shortcut (Accelerator) functionality"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.4"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kglobalacceld-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="89f72bbfb520b0dc8dfc6cbc81bdcfcf3b74217551b3ca81d0b96d9d35a09bcf"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, libx11, libxcb, xcb-util-keysyms, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kglobalaccel, kf6-kio, kf6-kjobwidgets, kf6-kservice, kf6-kwindowsystem"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
