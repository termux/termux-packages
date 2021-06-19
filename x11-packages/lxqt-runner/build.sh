TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt application launcher"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.17.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-runner/releases/download/${TERMUX_PKG_VERSION}/lxqt-runner-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=24a68c50961e1157aabdb9a3899727f50012b77e401c15447c9bdc3af792a358
TERMUX_PKG_DEPENDS="qt5-qtbase, libqtxdg, kwindowsystem, liblxqt, lxqt-globalkeys"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

# TODO runner math depends on muparser
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DRUNNER_MATH=OFF"
