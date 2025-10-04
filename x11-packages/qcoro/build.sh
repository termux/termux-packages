TERMUX_PKG_HOMEPAGE="https://github.com/danvratil/qcoro"
TERMUX_PKG_DESCRIPTION="C++ Coroutines for Qt"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux-user"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_SRCURL="https://github.com/danvratil/qcoro/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="809afafab61593f994c005ca6e242300e1e3e7f4db8b5d41f8c642aab9450fbc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebsockets"
TERMUX_PKG_BUILD_DEPENDS="cmake, git"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
