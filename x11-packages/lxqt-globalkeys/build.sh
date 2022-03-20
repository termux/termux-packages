TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Tools to set global keyboard shortcuts in LXQt sessions"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-globalkeys/releases/download/${TERMUX_PKG_VERSION}/lxqt-globalkeys-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b81944cc8d8f20f1eeedb3cd54d4e6ad86a1697d71b4212cf60110af43559a45
TERMUX_PKG_DEPENDS="qt5-qtbase, kwindowsystem, liblxqt, libx11"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

