TERMUX_PKG_HOMEPAGE=https://mpc-qt.github.io/
TERMUX_PKG_DESCRIPTION="Media Player Classic Qute Theater"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.07"
TERMUX_PKG_SRCURL="https://github.com/mpc-qt/mpc-qt/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=03cb0b02c67cab810147e5423c6f12c20d0b00b2bad200f38d117724e2ecf8e6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="mpv-x, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="qt6-qttools, qt6-qttools-cross-tools, qt6-qtbase-cross-tools, qt6-qtsvg-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
