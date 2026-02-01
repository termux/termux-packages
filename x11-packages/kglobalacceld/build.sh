TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kglobalacceld"
TERMUX_PKG_DESCRIPTION="Daemon providing Global Keyboard Shortcut (Accelerator) functionality"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kglobalacceld-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="6a3e52d957ed101e14d99e2d6830f54335017eebfaffddec8d4fcb765ddc0176"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kglobalaccel, kf6-kio, kf6-kjobwidgets, kf6-kservice, kf6-kwindowsystem, libc++, libx11, libxcb, qt6-qtbase, xcb-util-keysyms"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
