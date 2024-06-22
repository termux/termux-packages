TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="The core library of LXQt"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/liblxqt/releases/download/${TERMUX_PKG_VERSION}/liblxqt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b55073e7673e19d30339cabf5692a86b3aee244f3009f67e424b7c919f4d96f0
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtx11extras, kwindowsystem, libqtxdg, libxss"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_BACKLIGHT_LINUX_BACKEND=OFF"
TERMUX_PKG_AUTO_UPDATE=true
