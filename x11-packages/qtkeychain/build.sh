TERMUX_PKG_HOMEPAGE=https://github.com/frankosterfeld/qtkeychain
TERMUX_PKG_DESCRIPTION="Platform-independent Qt API for storing passwords securely."
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a22c708f351431d8736a0ac5c562414f2b7bb919a6292cbca1ff7ac0849cb0a7
TERMUX_PKG_DEPENDS="dbus, qt6-qtbase, libsecret, qt6-qttools"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_WITH_QT6=ON"
