TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="The core library of LXQt"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.17.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="https://github.com/lxqt/liblxqt/releases/download/${TERMUX_PKG_VERSION}/liblxqt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d44e3b4c0963537d5032328ac29bb0d61d454dc28d0fac7e1ddcb9d7be91c32b
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, kwindowsystem, libqtxdg, libxss"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_BACKLIGHT_LINUX_BACKEND=OFF"
