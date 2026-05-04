TERMUX_PKG_HOMEPAGE="https://www.qt.io/"
TERMUX_PKG_DESCRIPTION="Virtual keyboard framework"
TERMUX_PKG_LICENSE="GPL-3.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.0"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtvirtualkeyboard-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d88a4b1713a313e3ac06c32837b5d00724d1dcf7b44c2594f1029f7c74a8e686
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, hunspell, qt6-qtbase, qt6-qtdeclarative, qt6-qtpositioning, qt6-qtmultimedia, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="cmake, git, ninja"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
