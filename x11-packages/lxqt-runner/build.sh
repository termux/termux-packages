TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt application launcher"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-runner/releases/download/${TERMUX_PKG_VERSION}/lxqt-runner-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=1f9b61fef6420589b8d546c9b504364063e43de675b94020e215c35469852f4e
TERMUX_PKG_DEPENDS="qt5-qtbase, libqtxdg, kwindowsystem, liblxqt, lxqt-globalkeys"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

# TODO runner math depends on muparser
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DRUNNER_MATH=OFF"
