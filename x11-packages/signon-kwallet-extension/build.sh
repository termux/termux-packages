TERMUX_PKG_HOMEPAGE="https://invent.kde.org/network/signon-kwallet-extension"
TERMUX_PKG_DESCRIPTION="KWallet integration for signon framework"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/signon-kwallet-extension-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="4fc7566893bf8dd0d6e236d52e13319c809642b7e85f6680bcfbad47888a4836"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kwallet, libc++, qt6-qtbase, signond"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DINSTALL_BROKEN_SIGNON_EXTENSION=ON
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
