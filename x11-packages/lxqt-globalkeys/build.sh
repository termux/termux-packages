TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Tools to set global keyboard shortcuts in LXQt sessions"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.17.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-globalkeys/releases/download/${TERMUX_PKG_VERSION}/lxqt-globalkeys-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=90c409e95efefb2ee87e99504b955a2a84d4404157d2c1b7b7992b0571c4de5e
TERMUX_PKG_DEPENDS="qt5-qtbase, kwindowsystem, liblxqt"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

