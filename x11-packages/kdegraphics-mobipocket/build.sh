TERMUX_PKG_HOMEPAGE='https://invent.kde.org/graphics/kdegraphics-mobipocket'
TERMUX_PKG_DESCRIPTION='A library to handle mobipocket files'
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.04.1"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdegraphics-mobipocket-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e742b6a69099aea27807c0c856e161b2bd9859e8745cbb09ac51cb4dfd8d7bf9
TERMUX_PKG_DEPENDS="libc++, qt6-qt5compat, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQT_MAJOR_VERSION=6
"
