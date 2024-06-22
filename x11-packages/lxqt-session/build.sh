TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="The LXQt session manager"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-session/releases/download/${TERMUX_PKG_VERSION}/lxqt-session-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9dcdc846601f1972d01429f2203d36976088edcca5c166eef2b21ad73fcef656
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtx11extras, qtxdg-tools, kwindowsystem, liblxqt, procps, libandroid-wordexp"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_LIBUDEV=OFF"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure(){
	LDFLAGS+=" -landroid-wordexp"
}
