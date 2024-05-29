TERMUX_PKG_HOMEPAGE=https://audacious-media-player.org
TERMUX_PKG_DESCRIPTION="An advanced audio player"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://distfiles.audacious-media-player.org/audacious-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=85e9e26841505b51e342ee72a2d05f19bef894f567a029ebb3f3e0c1adb42042
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, dbus-glib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_RECOMMENDS="audacious-plugins"
# Audacious out-of-source build doesn't seem to work
TERMUX_PKG_BUILD_IN_SRC=true
# Audacious has switched to Qt toolkit and it's the default GUI option now
# Disable GTK to reduce the size and dependencies
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-qt --disable-gtk"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-enum-constexpr-conversion"
	CXXFLAGS+=" -Wno-enum-constexpr-conversion"
}
