TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="GUI to query passwords on behalf of SSH agents"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.17.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-openssh-askpass/releases/download/${TERMUX_PKG_VERSION}/lxqt-openssh-askpass-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=19322332443151ceadc24f4eea12188eb7dd08c77fb0f41dcd6ee92018f2ac3d
TERMUX_PKG_DEPENDS="qt5-qtbase, liblxqt"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

