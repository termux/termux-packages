TERMUX_PKG_HOMEPAGE='https://invent.kde.org/graphics/kdegraphics-mobipocket'
TERMUX_PKG_DESCRIPTION='A library to handle mobipocket files'
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.08.1"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdegraphics-mobipocket-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=19456126f4d1fd0c19a0a484dc27d5dd86399bc9a144d7ab89eb6479b110c920
TERMUX_PKG_DEPENDS="libc++, qt6-qt5compat, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQT_MAJOR_VERSION=6
"
