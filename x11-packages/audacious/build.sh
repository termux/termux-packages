TERMUX_PKG_HOMEPAGE=https://audacious-media-player.org
TERMUX_PKG_DESCRIPTION="An advanced audio player"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.4.1"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://distfiles.audacious-media-player.org/audacious-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=260d988d168e558f041bbb56692e24c535a96437878d60dfd01efdf6b1226416
TERMUX_PKG_DEPENDS="libarchive, libc++, qt6-qtbase, qt6-qtsvg, dbus-glib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools"
TERMUX_PKG_RECOMMENDS="audacious-plugins"
# Audacious out-of-source build doesn't seem to work
TERMUX_PKG_BUILD_IN_SRC=true
# Audacious has switched to Qt toolkit and it's the default GUI option now
# Disable GTK to reduce the size and dependencies
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libarchive
--disable-gtk
QTBINPATH=${TERMUX_PREFIX}/opt/qt6/cross/lib/qt6
"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-enum-constexpr-conversion"
	CXXFLAGS+=" -Wno-enum-constexpr-conversion"
}
