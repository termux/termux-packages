TERMUX_PKG_HOMEPAGE="https://www.qt.io/"
TERMUX_PKG_DESCRIPTION="Helps you create viable mapping solutions using the data available from some of the popular location services"
TERMUX_PKG_LICENSE="GPL-3.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.0"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtlocation-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=89b8386a8ae9e0b40a43fad398ac344f93a3b0d22f09bec4631f25d79135abef
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtpositioning"
TERMUX_PKG_BUILD_DEPENDS="cmake, git, ninja"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
