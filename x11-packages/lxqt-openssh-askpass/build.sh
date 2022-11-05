TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="GUI to query passwords on behalf of SSH agents"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-openssh-askpass/releases/download/${TERMUX_PKG_VERSION}/lxqt-openssh-askpass-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=721d975e7217b9a0ecdf125ca8111fc33ebb7a6e3c20a47e7d8a21a87514c670
TERMUX_PKG_DEPENDS="qt5-qtbase, liblxqt"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

