TERMUX_PKG_HOMEPAGE=https://audacious-media-player.org
TERMUX_PKG_DESCRIPTION="An advanced audio player"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.5"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://distfiles.audacious-media-player.org/audacious-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1ea5e0f871c6a8b2318e09a9d58fc573fe3f117ae0d8d163b60cc05b2ce7c405
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
