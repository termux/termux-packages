TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="GUI to query passwords on behalf of SSH agents"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-openssh-askpass/releases/download/${TERMUX_PKG_VERSION}/lxqt-openssh-askpass-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a012190131bd2935737127e43f5fa9f77ca59d897ad686e51c263f4db8bf9204
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, liblxqt"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

