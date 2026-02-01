TERMUX_PKG_HOMEPAGE="https://www.qt.io"
TERMUX_PKG_DESCRIPTION="Provides access to position, satellite and area monitoring classes"
TERMUX_PKG_LICENSE="GPL-3.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.10.2"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtpositioning-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7051fa64477c66769840cad396fc3772a01ba5516363c8842a7a513fa0c4cdce
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="geoclue, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtdeclarative"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
