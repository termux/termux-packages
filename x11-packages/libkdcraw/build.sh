TERMUX_PKG_HOMEPAGE=https://invent.kde.org/graphics/libkdcraw
TERMUX_PKG_DESCRIPTION="C++ interface used to decode RAW pictures"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/libkdcraw-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=1e4efcc416d8c2a3f5c1e3c1d458938ca243975fcda094b9101999175f505959
TERMUX_PKG_DEPENDS="libc++, libraw, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DQT_MAJOR_VERSION=6
"
