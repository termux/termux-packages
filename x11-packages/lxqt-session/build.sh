TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="The LXQt session manager"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-session/releases/download/${TERMUX_PKG_VERSION}/lxqt-session-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=74b2937619de662bf4b338589b9febadf6551e2e00a897351b4add69781e5c66
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, qtxdg-tools, kwindowsystem, liblxqt, procps, libandroid-wordexp"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_LIBUDEV=OFF"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure(){
	LDFLAGS+=" -landroid-wordexp"
}
