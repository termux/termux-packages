TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="The LXQt session manager"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-session/releases/download/${TERMUX_PKG_VERSION}/lxqt-session-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=5ca98a17eec1b6e084860d92764a34e4e21286a37b90796f1c523c0d576fb117
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, kwindowsystem, liblxqt, procps, libandroid-wordexp"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_LIBUDEV=OFF"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure(){
	LDFLAGS+=" -landroid-wordexp"
}
