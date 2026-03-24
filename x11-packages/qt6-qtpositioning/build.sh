TERMUX_PKG_HOMEPAGE="https://www.qt.io"
TERMUX_PKG_DESCRIPTION="Provides access to position, satellite and area monitoring classes"
TERMUX_PKG_LICENSE="GPL-3.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.0"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtpositioning-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d61fd0985ede513ec34d2d1c1e92f383eb8eb46678ca9da805cf795cccb796e9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="geoclue, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtdeclarative"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
