TERMUX_PKG_HOMEPAGE=https://github.com/Martchus/qtutilities
TERMUX_PKG_DESCRIPTION="Common Qt related C++ classes and routines used by my applications such as dialogs, widgets and models"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.10.0
TERMUX_PKG_SRCURL=https://github.com/Martchus/qtutilities/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=420dfea8864271bc8bac080edb7b8ba2aab1efd2f723e33793d2c8049a2ef935
TERMUX_PKG_DEPENDS="libc++, libc++utilities, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
