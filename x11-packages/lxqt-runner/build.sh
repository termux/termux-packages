TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt application launcher"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-runner/releases/download/${TERMUX_PKG_VERSION}/lxqt-runner-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d59fc6da61b6fde1f4c36216f7e18e157f6b8a2a48cdf6bb26380443494152d2
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, libqtxdg, kwindowsystem, liblxqt, lxqt-globalkeys"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

# TODO runner math depends on muparser
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DRUNNER_MATH=OFF"
