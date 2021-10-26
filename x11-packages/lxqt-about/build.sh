TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt dialog showing information about LXQt and the system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.17.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-about/releases/download/${TERMUX_PKG_VERSION}/lxqt-about-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f5033a4eb339f64de5b0eea32ee9178ab06aad6b60fd428fc196add785c33113
TERMUX_PKG_DEPENDS="qt5-qtbase, liblxqt"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools"

