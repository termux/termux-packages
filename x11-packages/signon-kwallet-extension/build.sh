TERMUX_PKG_HOMEPAGE="https://invent.kde.org/network/signon-kwallet-extension"
TERMUX_PKG_DESCRIPTION="KWallet integration for signon framework"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/signon-kwallet-extension-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=ad8ea5a4e40ce7f2481c694ff44822b89ab572746c4a6a552a0039041e2ea9d7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kwallet, libc++, qt6-qtbase, signond"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DINSTALL_BROKEN_SIGNON_EXTENSION=ON
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
