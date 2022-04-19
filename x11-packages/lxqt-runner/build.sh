TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt application launcher"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-runner/releases/download/${TERMUX_PKG_VERSION}/lxqt-runner-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=24daa86680ef78daf8753b60b3a0c6df391e760b851796a0abeddeed61ae13b9
TERMUX_PKG_DEPENDS="qt5-qtbase, libqtxdg, kwindowsystem, liblxqt, lxqt-globalkeys"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

# TODO runner math depends on muparser
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DRUNNER_MATH=OFF"
