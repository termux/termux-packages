TERMUX_PKG_HOMEPAGE=https://github.com/Martchus/qtutilities
TERMUX_PKG_DESCRIPTION="Common Qt related C++ classes and routines used by my applications such as dialogs, widgets and models"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.11.0
TERMUX_PKG_SRCURL=https://github.com/Martchus/qtutilities/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b49fabea6f86a3665c4e3e7d4a9a4d4392549ce942f5de4f21b694126fea23b
TERMUX_PKG_DEPENDS="libc++, libc++utilities, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
