TERMUX_PKG_HOMEPAGE="https://www.qt.io"
TERMUX_PKG_DESCRIPTION="Provides access to position, satellite and area monitoring classes"
TERMUX_PKG_LICENSE="GPL-3.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.10.1"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtpositioning-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="abb311ef1bd6e39f090d22480e265d13f8537d2e2f4c88f22d6519547f46be23"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="geoclue, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtdeclarative"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
