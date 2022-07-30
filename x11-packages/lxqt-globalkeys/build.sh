TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Tools to set global keyboard shortcuts in LXQt sessions"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-globalkeys/releases/download/${TERMUX_PKG_VERSION}/lxqt-globalkeys-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=948067da6170ef4a46134367b699f3465fa6161cf5bd36b7c580a7a254417c2d
TERMUX_PKG_DEPENDS="qt5-qtbase, kwindowsystem, liblxqt, libx11"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

