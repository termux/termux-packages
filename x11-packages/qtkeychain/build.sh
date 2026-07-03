TERMUX_PKG_HOMEPAGE=https://github.com/frankosterfeld/qtkeychain
TERMUX_PKG_DESCRIPTION="Platform-independent Qt API for storing passwords securely."
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.0"
TERMUX_PKG_SRCURL="https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3be26ec4ae30eecf0c2ff7572ba83799791b157c76e15a05ef35f23dc25e4054
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, glib, libc++, libsecret, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_WITH_QT6=ON"
