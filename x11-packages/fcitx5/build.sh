TERMUX_PKG_HOMEPAGE=https://fcitx-im.org/
TERMUX_PKG_DESCRIPTION="A generic input method framework"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.19"
TERMUX_PKG_SRCURL=https://github.com/fcitx/fcitx5/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a6e4d99a82298845df9f8dc5036c1aaed258c2d3f5bd215b8f91c75410167ff0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="dbus, enchant, fcitx5-data, fmt, gdk-pixbuf, glib, iso-codes, libandroid-execinfo, libc++, libcairo, libevent, libexpat, libuuid, libuv, libxcb, libxkbcommon, libxkbfile, pango, xcb-imdkit, xcb-util, xcb-util-keysyms, xcb-util-wm, yoga, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, nlohmann-json"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DDL_INCLUDE_DIR=$TERMUX_PREFIX/include
-DDL_LIBRARY=0
-DPTHREAD_INCLUDE_DIR=$TERMUX_PREFIX/include
-DENABLE_TEST=OFF
-DENABLE_WAYLAND=OFF
-DUSE_SYSTEM_YOGA=ON
"

termux_step_pre_configure() {
	LDFLAGS+=" -ldl"
	CXXFLAGS+=" -fexperimental-library"
}
