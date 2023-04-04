TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt dialog showing information about LXQt and the system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-about/releases/download/${TERMUX_PKG_VERSION}/lxqt-about-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=593fa4382b7f86abe5355b8e56cc07fea59de50a899d6164030297fc210e5075
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, liblxqt"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

